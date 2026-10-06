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

class WheelSliceData {
  const WheelSliceData({required this.label, this.image});

  final String label;
  final ui.Image? image;
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
  });

  final List<WheelSliceData> slices;
  final List<double> sweeps;
  final double rotation;
  final Color rimColor;
  final WheelContent content;
  final bool flipText;
  final TextStyle labelStyle;

  static const _photoShadows = [Shadow(blurRadius: 4), Shadow(blurRadius: 2)];

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final center = size.center(Offset.zero);
    final count = slices.length;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    var start = -pi / 2;
    for (var i = 0; i < count; i++) {
      final sweep = sweeps[i];
      final slice = slices[i];
      final color = sliceColor(i, count);
      final wedge = _wedge(radius, start, sweep);
      canvas.drawPath(wedge, Paint()..color = color);
      final image = content == WheelContent.text ? null : slice.image;
      if (image != null) _paintPhoto(canvas, wedge, image, radius, start + sweep / 2, sweep);
      if (count > 1) {
        canvas.drawLine(
          Offset.zero,
          Offset(cos(start), sin(start)) * radius,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.6)
            ..strokeWidth = 1.5,
        );
      }
      if (image == null || content == WheelContent.both) {
        _paintLabel(canvas, radius, start + sweep / 2, sweep, slice.label, color, onPhoto: image != null);
      }
      start += sweep;
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
