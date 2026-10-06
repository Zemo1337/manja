import 'dart:math';

import 'package:flutter/material.dart';

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

class WheelPainter extends CustomPainter {
  WheelPainter({required this.labels, required this.rotation, required this.rimColor});

  final List<String> labels;
  final double rotation;
  final Color rimColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final count = labels.length;
    final sweep = 2 * pi / count;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.translate(-center.dx, -center.dy);

    for (var i = 0; i < count; i++) {
      final start = -pi / 2 + i * sweep;
      final color = sliceColor(i, count);
      canvas.drawArc(rect, start, sweep, true, Paint()..color = color);
      if (count > 1) {
        canvas.drawArc(
          rect,
          start,
          sweep,
          true,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
      _paintLabel(canvas, center, radius, start + sweep / 2, labels[i], color, count);
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

  void _paintLabel(Canvas canvas, Offset center, double radius, double angle, String text, Color bg, int count) {
    final fontSize = (radius * 0.11).clamp(10.0, 20.0) * (count > 12 ? 0.8 : 1.0);
    final textColor = bg.computeLuminance() > 0.45 ? Colors.black87 : Colors.white;
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: radius * 0.68);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    painter.paint(canvas, Offset(radius * 0.9 - painter.width, -painter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) =>
      oldDelegate.rotation != rotation || oldDelegate.labels != labels || oldDelegate.rimColor != rimColor;
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

double targetRotation({
  required double current,
  required int index,
  required int count,
  required int fullSpins,
  double jitter = 0,
}) {
  final sweep = 2 * pi / count;
  final desired = -(index + 0.5 + jitter) * sweep;
  final delta = (desired - current) % (2 * pi);
  return current + fullSpins * 2 * pi + delta;
}

int indexAtPointer(double rotation, int count) {
  final sweep = 2 * pi / count;
  final local = (-rotation) % (2 * pi);
  return (local / sweep).floor() % count;
}
