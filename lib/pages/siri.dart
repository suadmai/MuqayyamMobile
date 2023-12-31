import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';

class SiriWave extends StatefulWidget {
  @override
  _SiriWaveState createState() => _SiriWaveState();
}

class _SiriWaveState extends State<SiriWave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Siri Wave'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: SvgPicture.asset(
            'lib/icons/icons_Track_Prayer.svg',
            fit: BoxFit.contain,
          ),
          ),
        ),
      );
  }
}

class SiriWavePainter extends CustomPainter {
  final Animation<double> animation;

  SiriWavePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (double i = 0; i < 360; i += 5) {
      final radians = math.pi / 180 * i;
      final x = centerX + math.cos(radians) * (radius + math.sin(animation.value * math.pi * 2 + i * 0.1) * 10);
      final y = centerY + math.sin(radians) * (radius + math.sin(animation.value * math.pi * 2 + i * 0.1) * 10);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

