import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/wheel_layout.dart';
import '../../domain/wheel_service.dart';
import 'wheel_themes.dart';

class WheelSliceData {
  const WheelSliceData({required this.label, this.image, this.isOverflow = false});

  final String label;
  final ui.Image? image;
  final bool isOverflow;
}

class WheelPainter extends CustomPainter {
  WheelPainter({
    required this.slices,
    required this.sweeps,
    required this.rotation,
    required this.theme,
    this.content = WheelContent.text,
    this.flipText = true,
    this.labelStyle = const TextStyle(),
    this.highlight,
  });

  final List<WheelSliceData> slices;
  final List<double> sweeps;
  final double rotation;
  final WheelTheme theme;
  final WheelContent content;
  final bool flipText;
  final TextStyle labelStyle;
  final int? highlight;

  static const _photoShadows = [Shadow(blurRadius: 4), Shadow(blurRadius: 2)];
  static const _minSweep = 1e-4;
  static const _wideSweep = 1.9;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = min(size.width, size.height) / 2;
    final radius = outer * (1 - theme.rimFraction);
    final center = size.center(Offset.zero);
    final count = slices.length;
    final starts = <double>[];
    var angle = -pi / 2;
    for (final sweep in sweeps) {
      starts.add(angle);
      angle += sweep;
    }
    final colors = [for (var i = 0; i < count; i++) slices[i].isOverflow ? theme.overflow : theme.sliceColor(i, count)];
    final visible = [
      for (var i = 0; i < count; i++)
        if (sweeps[i] > _minSweep) i,
    ];

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (final i in visible) {
      canvas.drawPath(_wedge(radius, starts[i], sweeps[i]), Paint()..color = colors[i]);
    }
    theme.paintSurface(canvas, radius);
    for (final i in visible) {
      final image = _imageFor(i);
      if (image != null) {
        _paintPhoto(canvas, _wedge(radius, starts[i], sweeps[i]), image, radius, starts[i] + sweeps[i] / 2, sweeps[i]);
      }
    }
    if (visible.length > 1) {
      final divider = Paint()
        ..color = theme.divider
        ..strokeWidth = 1.5;
      for (final i in visible) {
        canvas.drawLine(Offset.zero, Offset(cos(starts[i]), sin(starts[i])) * radius, divider);
      }
    }
    final h = highlight;
    if (h != null && sweeps[h] > _minSweep) {
      canvas.drawPath(
        _wedge(radius - 2, starts[h], sweeps[h]),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeJoin = StrokeJoin.round,
      );
    }
    for (final i in visible) {
      final image = _imageFor(i);
      if (image != null && content != WheelContent.both) continue;
      final mid = starts[i] + sweeps[i] / 2;
      if (sweeps[i] < _wideSweep) {
        _paintLabel(canvas, radius, mid, sweeps[i], slices[i].label, colors[i], onPhoto: image != null);
      } else {
        _paintWideLabel(canvas, radius, mid, sweeps[i], slices[i].label, colors[i], onPhoto: image != null);
      }
    }
    theme.paintRim(canvas, outer, radius);
    theme.paintHub(canvas, outer);
    canvas.restore();
  }

  ui.Image? _imageFor(int i) => content == WheelContent.text ? null : slices[i].image;

  Path _wedge(double radius, double start, double sweep) {
    if (sweep >= fullTurn - 1e-6) return Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius));
    return Path()
      ..moveTo(0, 0)
      ..arcTo(Rect.fromCircle(center: Offset.zero, radius: radius), start, sweep, false)
      ..close();
  }

  void _paintPhoto(Canvas canvas, Path wedge, ui.Image image, double radius, double mid, double sweep) {
    canvas.save();
    canvas.clipPath(wedge);
    canvas.rotate(mid + pi / 2);
    final Rect rect;
    if (sweep >= pi) {
      rect = Rect.fromCircle(center: Offset.zero, radius: radius);
    } else {
      final halfWidth = radius * sin(sweep / 2);
      rect = Rect.fromLTRB(-halfWidth, -radius, halfWidth, 0);
    }
    paintImage(canvas: canvas, rect: rect, image: image, fit: BoxFit.cover, filterQuality: FilterQuality.medium);
    if (content == WheelContent.both) canvas.drawRect(rect, Paint()..color = const Color(0x33000000));
    canvas.restore();
  }

  void _paintLabel(
    Canvas canvas,
    double radius,
    double angle,
    double sweep,
    String text,
    Color bg, {
    required bool onPhoto,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: labelStyle.copyWith(
          color: onPhoto ? Colors.white : theme.labelColor(bg),
          fontSize: labelFontSize(sweep: sweep, radius: radius),
          fontWeight: FontWeight.w600,
          shadows: onPhoto ? _photoShadows : null,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: radius * 0.62);

    final flip = flipText && shouldFlipLabel(angle + rotation);
    canvas.save();
    canvas.rotate(flip ? angle + pi : angle);
    final dx = flip ? -radius * 0.9 : radius * 0.9 - painter.width;
    painter.paint(canvas, Offset(dx, -painter.height / 2));
    canvas.restore();
  }

  void _paintWideLabel(
    Canvas canvas,
    double radius,
    double angle,
    double sweep,
    String text,
    Color bg, {
    required bool onPhoto,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: labelStyle.copyWith(
          color: onPhoto ? Colors.white : theme.labelColor(bg),
          fontSize: (radius * 0.13).clamp(14.0, 30.0),
          fontWeight: FontWeight.w700,
          shadows: onPhoto ? _photoShadows : null,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: radius * (sweep >= pi ? 1.3 : 0.9));

    final flip = flipText && shouldFlipWideLabel(angle + rotation);
    final outward = sweep >= 1.5 * pi ? radius * 0.45 : -radius * 0.58;
    final y = flip ? -outward : outward;
    canvas.save();
    canvas.rotate(angle + pi / 2 + (flip ? pi : 0));
    painter.paint(canvas, Offset(-painter.width / 2, y - painter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => true;
}

class WheelPointerPainter extends CustomPainter {
  WheelPointerPainter(this.color, {this.outline});

  static Size sizeFor(double wheel) {
    final width = (wheel * 0.11).clamp(24.0, 56.0);
    return Size(width, width * 1.53);
  }

  final Color color;
  final Color? outline;

  static Path head(Size size) {
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(0, h * 0.34)
      ..lineTo(w, h * 0.34)
      ..quadraticBezierTo(w, h * 0.58, w * 0.66, h * 0.64)
      ..lineTo(w * 0.5, h)
      ..lineTo(w * 0.34, h * 0.64)
      ..quadraticBezierTo(0, h * 0.58, 0, h * 0.34)
      ..close();
  }

  static List<(Offset, Offset)> tines(Size size) => [
    for (var i = 0; i < 4; i++)
      (
        Offset(size.width * (0.11 + i * 0.26), size.height * 0.05),
        Offset(size.width * (0.11 + i * 0.26), size.height * 0.38),
      ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final head = WheelPointerPainter.head(size);
    final tineWidth = size.width * 0.15;
    canvas.drawShadow(head, Colors.black, 3, false);
    final edge = outline;
    if (edge != null && edge != color) {
      final stroke = Paint()
        ..color = edge
        ..strokeWidth = tineWidth + 3
        ..strokeCap = StrokeCap.round;
      for (final (a, b) in tines(size)) {
        canvas.drawLine(a, b, stroke);
      }
      canvas.drawPath(
        head,
        Paint()
          ..color = edge
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeJoin = StrokeJoin.round,
      );
    }
    final fill = Paint()
      ..color = color
      ..strokeWidth = tineWidth
      ..strokeCap = StrokeCap.round;
    for (final (a, b) in tines(size)) {
      canvas.drawLine(a, b, fill);
    }
    canvas.drawPath(head, Paint()..color = color);
  }

  @override
  bool shouldRepaint(WheelPointerPainter oldDelegate) => oldDelegate.color != color || oldDelegate.outline != outline;
}
