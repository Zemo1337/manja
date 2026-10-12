import 'dart:math';

import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'wheel/wheel_painter.dart';

const _cream = Color(0xFFFFF4EC);
const _paprika = Color(0xFFC2410C);
const _saffron = Color(0xFFE9A000);
const _basil = Color(0xFF2E7D32);
const _ink = Color(0xFF5C1F05);
const _wood = Color(0xFFE3B778);
const _woodDark = Color(0xFFC98F4A);
const _woodLight = Color(0xFFF8E3BB);
const _woodShade = Color(0xFFA9773A);
const _woodBodyShade = Color(0xFFC99350);
const _saffronLight = Color(0xFFF6D27A);

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

/// The half wheel with a fork pointer resting on a two-tone rolling pin, drawn on a 100 × 100 grid.
class AppLogoPainter extends CustomPainter {
  const AppLogoPainter({this.background = true, this.scale = 1, this.centerY = 44});

  static const saffron = _saffronLight;

  final bool background;
  final double scale;

  /// The point of the drawing placed at the middle; larger values move the logo up, which lets round masks fit it bigger.
  final double centerY;

  @override
  void paint(Canvas canvas, Size size) {
    final s = min(size.width, size.height);
    if (background) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Offset.zero & Size.square(s), Radius.circular(s * 0.22)),
        Paint()..color = _saffronLight,
      );
    }
    canvas.save();
    canvas.translate(s / 2, s / 2);
    canvas.scale(scale * s / 100);
    canvas.translate(-51, -centerY);

    const center = Offset(50, 64);
    const radius = 33.0;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const colors = [_paprika, _saffron, _basil, _paprika];
    for (var i = 0; i < 4; i++) {
      canvas.drawArc(rect, pi + i * pi / 4, pi / 4, true, Paint()..color = colors[i]);
    }
    final divider = Paint()
      ..color = _cream
      ..strokeWidth = 1.6;
    for (var i = 1; i < 4; i++) {
      final a = pi + i * pi / 4;
      canvas.drawLine(center, center + Offset(cos(a), sin(a)) * radius, divider);
    }
    canvas.drawArc(
      rect,
      pi,
      pi,
      false,
      Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    canvas.save();
    canvas.translate(42, 3.5);
    canvas.drawPath(WheelPointerPainter.shape(const Size(16, 28.5)), Paint()..color = _ink);
    canvas.restore();

    final handles = [
      for (final x in const [3.0, 84.0])
        RRect.fromRectAndRadius(Rect.fromLTWH(x, 66, 13, 9), const Radius.circular(4.5)),
    ];
    final body = RRect.fromRectAndRadius(const Rect.fromLTWH(15, 61, 70, 19), const Radius.circular(2.5));
    final shadow = Paint()..color = _ink.withValues(alpha: 0.22);
    canvas.save();
    canvas.translate(2.5, 3.5);
    for (final h in [...handles, body]) {
      canvas.drawRRect(h, shadow);
    }
    canvas.restore();

    void twoTone(RRect shape, Color light, Color dark) {
      canvas.save();
      canvas.clipRRect(shape);
      canvas.drawRect(shape.outerRect, Paint()..color = light);
      canvas.drawRect(Rect.fromLTRB(shape.left, 70.5, shape.right, shape.bottom), Paint()..color = dark);
      canvas.restore();
    }

    final outline = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke;
    for (final h in handles) {
      twoTone(h, _woodDark, _woodShade);
      canvas.drawRRect(h, outline..strokeWidth = 1.8);
    }
    twoTone(body, _wood, _woodBodyShade);
    canvas.drawRRect(body, outline..strokeWidth = 2.4);
    canvas.drawLine(
      const Offset(19, 65),
      const Offset(81, 65),
      Paint()
        ..color = _woodLight
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(AppLogoPainter oldDelegate) =>
      oldDelegate.background != background || oldDelegate.scale != scale || oldDelegate.centerY != centerY;
}

/// "Manja" in the title font with the chef's hat sitting on the M.
class ManjaWordmark extends StatelessWidget {
  const ManjaWordmark({super.key, this.fontSize = 30, this.color});

  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final titleColor = color ?? Theme.of(context).appBarTheme.titleTextStyle?.color ?? _cream;
    final painter = _WordmarkPainter(fontSize: fontSize, color: titleColor);
    return Semantics(
      label: 'Manja',
      child: CustomPaint(size: painter.measure(), painter: painter),
    );
  }
}

class _WordmarkPainter extends CustomPainter {
  _WordmarkPainter({required this.fontSize, required this.color})
    : _text = TextPainter(
        text: TextSpan(
          text: 'Manja',
          style: TextStyle(fontFamily: appTitleFont, fontSize: fontSize, color: color, height: 1),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

  // Designed in an SVG where "Manja" is 58 px Lobster starting at x 10 on baseline 100, and the hat fits above y 0.
  static const _designSize = 58.0;
  static const _left = 4.0;
  static const _above = 100.0;

  final double fontSize;
  final Color color;
  final TextPainter _text;

  double get _unit => fontSize / _designSize;

  double get _baseline => _text.computeDistanceToActualBaseline(TextBaseline.alphabetic);

  Size measure() => Size((_left + 2) * _unit + _text.width, _above * _unit + _text.height - _baseline);

  @override
  void paint(Canvas canvas, Size size) {
    final baselineY = _above * _unit;
    _text.paint(canvas, Offset(_left * _unit, baselineY - _baseline));
    canvas.save();
    canvas.translate(_left * _unit, baselineY);
    canvas.scale(_unit);
    canvas.translate(-10 - 8.8, -100 + 24.26);
    canvas.scale(0.3412);
    canvas.translate(48, 6);
    canvas.translate(52, 80);
    canvas.rotate(-20 * pi / 180);
    canvas.translate(-52, -80);
    canvas.scale(1.15);
    paintChefHat(canvas);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WordmarkPainter oldDelegate) => oldDelegate.fontSize != fontSize || oldDelegate.color != color;
}

/// The chef's hat from the wordmark on its own 0–110 × 0–92 grid.
void paintChefHat(Canvas canvas) {
  final fill = Paint()..color = Colors.white;
  final line = Paint()
    ..color = _ink
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;
  final puff = Path()
    ..moveTo(26, 74)
    ..cubicTo(6, 76, -2, 56, 10, 44)
    ..cubicTo(0, 26, 18, 6, 38, 14)
    ..cubicTo(44, -2, 70, -4, 78, 12)
    ..cubicTo(98, 6, 110, 30, 96, 46)
    ..cubicTo(106, 58, 94, 76, 72, 72)
    ..close();
  canvas.drawPath(puff, fill);
  canvas.drawPath(puff, line..strokeWidth = 3.4);
  canvas.drawPath(
    Path()
      ..moveTo(40, 70)
      ..cubicTo(39, 60, 34, 50, 27, 43)
      ..moveTo(58, 70)
      ..cubicTo(60, 60, 66, 50, 74, 44),
    line..strokeWidth = 2.2,
  );
  final band = Path()
    ..moveTo(24, 71)
    ..lineTo(72, 69)
    ..lineTo(71, 88)
    ..quadraticBezierTo(48, 92, 26, 89)
    ..close();
  canvas.drawPath(band, fill);
  canvas.drawPath(band, line..strokeWidth = 3.4);
}
