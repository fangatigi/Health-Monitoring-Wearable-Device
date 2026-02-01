import 'dart:math';
import 'package:flutter/material.dart';

class EcgWave extends StatefulWidget {
  final int sample;

  const EcgWave({
    super.key,
    required this.sample,
  });

  @override
  State<EcgWave> createState() => _EcgWaveState();
}

class _EcgWaveState extends State<EcgWave> {
  static const int maxPoints = 250;
  final List<double> _buffer = [];

  @override
  void didUpdateWidget(covariant EcgWave oldWidget) {
    super.didUpdateWidget(oldWidget);

    double v = widget.sample.toDouble();

    if (!v.isFinite) v = 0;

    _buffer.add(v);

    if (_buffer.length > maxPoints) {
      _buffer.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 140),
      painter: _EcgPainter(_buffer),
    );
  }
}

class _EcgPainter extends CustomPainter {
  final List<double> points;

  _EcgPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    // ===== GRID =====
    final gridPaint = Paint()
      ..color = Colors.red.withOpacity(0.15)
      ..strokeWidth = 1;

    const int gridCount = 10;
    for (int i = 0; i <= gridCount; i++) {
      final dx = size.width * i / gridCount;
      final dy = size.height * i / gridCount;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    // ===== ECG TRACE =====
    final tracePaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final minV = points.reduce(min);
    final maxV = points.reduce(max);
    final range = max(1, maxV - minV);

    final path = Path();

    for (int i = 0; i < points.length; i++) {
      final x = i * size.width / (points.length - 1);
      final y = size.height -
          ((points[i] - minV) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, tracePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
