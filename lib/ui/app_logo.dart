import 'dart:math';

import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 32, this.background = false});

  final double size;
  final bool background;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: AppLogoPainter(background: background),
  );
}

class AppLogoPainter extends CustomPainter {
  const AppLogoPainter({this.background = true, this.scale = 1});

  static const cream = Color(0xFFFFF4EC);
  static const _plate = Color(0xFFF3E9DF);
  static const _rim = Color(0xFFE2D3C4);
  static const _paprika = Color(0xFFC2410C);
  static const _saffron = Color(0xFFE9A000);
  static const _basil = Color(0xFF2E7D32);
  static const _fork = Color(0xFF5C1F05);

  final bool background;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final s = min(size.width, size.height);
    if (background) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & Size.square(s), Radius.circular(s * 0.23)),
        Paint()..color = cream,
      );
    }
    canvas.save();
    canvas.translate(s / 2, s / 2);
    canvas.scale(scale);
    canvas.translate(-s / 2, -s / 2);

    final center = Offset(s * 0.5, s * 0.55);
    canvas.drawCircle(center, s * 0.37, Paint()..color = _plate);
    canvas.drawCircle(
      center,
      s * 0.37,
      Paint()
        ..color = _rim
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.012,
    );
    final rect = Rect.fromCircle(center: center, radius: s * 0.3);
    const colors = [_paprika, _saffron, _basil];
    for (var i = 0; i < 6; i++) {
      canvas.drawArc(rect, -pi / 2 + i * pi / 3, pi / 3, true, Paint()..color = colors[i % 3]);
    }
    final divider = Paint()
      ..color = _plate
      ..strokeWidth = s * 0.012;
    for (var i = 0; i < 6; i++) {
      final a = -pi / 2 + i * pi / 3;
      canvas.drawLine(center, center + Offset(cos(a), sin(a)) * s * 0.3, divider);
    }
    canvas.drawCircle(center, s * 0.065, Paint()..color = _plate);

    final fork = Paint()..color = _fork;
    final tine = Paint()
      ..color = _fork
      ..strokeWidth = s * 0.026
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 4; i++) {
      final x = s * (0.437 + i * 0.042);
      canvas.drawLine(Offset(x, s * 0.035), Offset(x, s * 0.12), tine);
    }
    canvas.drawPath(
      Path()
        ..moveTo(s * 0.42, s * 0.11)
        ..lineTo(s * 0.58, s * 0.11)
        ..quadraticBezierTo(s * 0.58, s * 0.17, s * 0.53, s * 0.19)
        ..lineTo(s * 0.5, s * 0.255)
        ..lineTo(s * 0.47, s * 0.19)
        ..quadraticBezierTo(s * 0.42, s * 0.17, s * 0.42, s * 0.11)
        ..close(),
      fork,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(AppLogoPainter oldDelegate) => oldDelegate.background != background || oldDelegate.scale != scale;
}
