import 'dart:math';

import 'package:flutter/material.dart';

/// เส้นแบ่งโค้งคลื่น (sine wave) — ใช้ระหว่าง section ใน TestResult
class WaveDivider extends StatelessWidget {
  const WaveDivider({
    super.key,
    required this.color,
    this.height = 16,
    this.amplitude = 4,
    this.waveLength = 28,
    this.strokeWidth = 2,
  });

  final Color color;
  final double height;
  final double amplitude;
  final double waveLength;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _WavePainter(
          color: color,
          amplitude: amplitude,
          waveLength: waveLength,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter({
    required this.color,
    required this.amplitude,
    required this.waveLength,
    required this.strokeWidth,
  });

  final Color color;
  final double amplitude;
  final double waveLength;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final centerY = size.height / 2;
    path.moveTo(0, centerY);

    for (var x = 0.0; x <= size.width; x += 1) {
      final y = centerY + amplitude * sin((x / waveLength) * 2 * pi);
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.waveLength != waveLength ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
