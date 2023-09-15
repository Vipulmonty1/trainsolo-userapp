import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Draws a circular animated progress bar.
class CircleProgress extends CustomPainter {
  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 7
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 7
      ..color = Color.fromARGB(255, 237, 28, 36)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2) - 10;

    canvas.drawCircle(
        center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // ignore: todo
    // TODO: implement shouldRepaint
    return true;
  }
}
