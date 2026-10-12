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

/// The finish of the fork that points at the winner.
enum ForkMetal {
  silver([Color(0xFFF7F9FA), Color(0xFFC9CFD4), Color(0xFF8D969E), Color(0xFFDCE1E5)], Color(0xFF4F575E)),
  gold([Color(0xFFFFF3C4), Color(0xFFEBC35B), Color(0xFFB07F22), Color(0xFFF3D47E)], Color(0xFF6B4610));

  const ForkMetal(this.sheen, this.edge);

  /// Colours across the fork from left to right, like light falling on a curved spoon.
  final List<Color> sheen;
  final Color edge;
}

class WheelPointerPainter extends CustomPainter {
  WheelPointerPainter(this.metal);

  static Size sizeFor(double wheel) {
    final width = (wheel * 0.11).clamp(24.0, 56.0);
    return Size(width, width * 1.53);
  }

  final ForkMetal metal;

  /// Four pointed prongs on a rounded head that narrows into the tip touching the wheel.
  static Path shape(Size size) {
    final w = size.width;
    final h = size.height;
    var fork = Path()
      ..moveTo(w * 0.05, h * 0.34)
      ..lineTo(w * 0.95, h * 0.34)
      ..cubicTo(w * 0.95, h * 0.56, w * 0.64, h * 0.6, w * 0.59, h * 0.68)
      ..lineTo(w * 0.5, h)
      ..lineTo(w * 0.41, h * 0.68)
      ..cubicTo(w * 0.36, h * 0.6, w * 0.05, h * 0.56, w * 0.05, h * 0.34)
      ..close();
    const prong = 0.15;
    const gap = (0.9 - 4 * prong) / 3;
    for (var i = 0; i < 4; i++) {
      final left = w * (0.05 + i * (prong + gap));
      final right = left + w * prong;
      final mid = (left + right) / 2;
      final tine = Path()
        ..moveTo(left, h * 0.4)
        ..lineTo(left, h * 0.16)
        ..quadraticBezierTo(left, h * 0.07, mid, 0)
        ..quadraticBezierTo(right, h * 0.07, right, h * 0.16)
        ..lineTo(right, h * 0.4)
        ..close();
      fork = Path.combine(PathOperation.union, fork, tine);
      if (i < 3) {
        final radius = w * gap / 2;
        final slot = Rect.fromLTRB(right, h * 0.34 - radius * 2, right + radius * 2, h * 0.35);
        final fillet = Path.combine(
          PathOperation.difference,
          Path()..addRect(slot),
          Path()..addOval(Rect.fromCircle(center: Offset(right + radius, slot.top), radius: radius)),
        );
        fork = Path.combine(PathOperation.union, fork, fillet);
      }
    }
    return fork;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final fork = shape(size);
    canvas.drawShadow(fork, Colors.black, 3, false);
    canvas.drawPath(
      fork,
      Paint()
        ..shader = LinearGradient(colors: metal.sheen, stops: const [0, 0.35, 0.7, 1]).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      fork,
      Paint()
        ..color = metal.edge
        ..style = PaintingStyle.stroke
        ..strokeWidth = max(1.2, size.width * 0.035)
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(WheelPointerPainter oldDelegate) => oldDelegate.metal != metal;
}
