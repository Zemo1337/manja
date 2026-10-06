import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../domain/wheel_layout.dart';
import '../../domain/wheel_service.dart';

const wheelPalette = [
  Color(0xFFE4572E),
  Color(0xFFF3A712),
  Color(0xFF29335C),
  Color(0xFF669BBC),
  Color(0xFF7FB069),
  Color(0xFFA8325E),
];

Color sliceColor(int index, int count) {
  final last = count > 1 && index == count - 1 && index % wheelPalette.length == 0;
  return wheelPalette[last ? 1 : index % wheelPalette.length];
}

const overflowSliceColor = Color(0xFF4A3F3B);

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
    required this.rimColor,
    this.content = WheelContent.text,
    this.flipText = true,
    this.labelStyle = const TextStyle(),
    this.highlight,
  });

  final List<WheelSliceData> slices;
  final List<double> sweeps;
  final double rotation;
  final Color rimColor;
  final WheelContent content;
  final bool flipText;
  final TextStyle labelStyle;
  final int? highlight;

  static const _photoShadows = [Shadow(blurRadius: 4), Shadow(blurRadius: 2)];
  static const _minSweep = 1e-4;
  static const _wideSweep = 1.9;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final center = size.center(Offset.zero);
    final count = slices.length;
    final starts = <double>[];
    var angle = -pi / 2;
    for (final sweep in sweeps) {
      starts.add(angle);
      angle += sweep;
    }
    final colors = [for (var i = 0; i < count; i++) slices[i].isOverflow ? overflowSliceColor : sliceColor(i, count)];
    final visible = [for (var i = 0; i < count; i++) if (sweeps[i] > _minSweep) i];

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    for (final i in visible) {
      final wedge = _wedge(radius, starts[i], sweeps[i]);
      canvas.drawPath(wedge, Paint()..color = colors[i]);
      final image = _imageFor(i);
      if (image != null) _paintPhoto(canvas, wedge, image, radius, starts[i] + sweeps[i] / 2, sweeps[i]);
    }
    if (visible.length > 1) {
      final divider = Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
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
    canvas.restore();

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = rimColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6,
    );
    canvas.drawCircle(center, radius * 0.12, Paint()..color = rimColor);
    canvas.drawCircle(center, radius * 0.07, Paint()..color = Colors.white);
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
          color: onPhoto || bg.computeLuminance() <= 0.45 ? Colors.white : Colors.black87,
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
          color: onPhoto || bg.computeLuminance() <= 0.45 ? Colors.white : Colors.black87,
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

    final y = sweep >= 1.5 * pi ? radius * 0.45 : -radius * 0.58;
    canvas.save();
    canvas.rotate(angle + pi / 2);
    painter.paint(canvas, Offset(-painter.width / 2, y - painter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => true;
}

class WheelPointerPainter extends CustomPainter {
  WheelPointerPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawShadow(path, Colors.black, 3, false);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(WheelPointerPainter oldDelegate) => oldDelegate.color != color;
}
