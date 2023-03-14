// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:math';

import 'package:flutter/material.dart';

import '../../app_theme_data.dart';
import '../../strs.dart';
import '../../widgets/animated_text.dart';
import '../../widgets/movable.dart';
import 'level_obj_controller.dart';

class L2ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L2ObjController() {
    currentObj = objects['']!;
  }

  bool isThemeChanged = false;

  @override
  void runCommandTheme(BuildContext context, String str) {
    final arg =
        str.split(':').last == 'black' ? Brightness.dark : Brightness.light;
    if (Theme.of(context).brightness == arg) return;

    isThemeChanged = !isThemeChanged;

    super.runCommandTheme(context, str);
  }

  @override
  bool isLevelPassed() {
    return isThemeChanged;
  }
}

class L2 extends StatefulWidget {
  const L2(this.controller, {super.key});

  final L2ObjController controller;

  @override
  State<L2> createState() => _L2State();
}

class _L2State extends State<L2> {
  Color? cageColor;
  @override
  Widget build(BuildContext context) {
    cageColor ??= Theme.of(context).brightness == Brightness.light
        ? AppThemeData.darkColorScheme.background
        : AppThemeData.lightColorScheme.background;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(100),
              child: AnimatedTextFixed(
                Text(
                  Strs.l2S1,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
          MovableObject(
            state: widget.controller.getObj(''),
            alignment: Alignment.bottomCenter,
            initPosition: const Offset(0, -50),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Image.asset(
                    'assets/l1/bird.png',
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: CustomPaint(
                    painter: _CagePainter(
                      color:
                          cageColor! == Theme.of(context).colorScheme.background
                              ? Colors.transparent
                              : cageColor!,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CagePainter extends CustomPainter {
  final Paint _paint;
  final Color color;
  final double strokeWidth;

  _CagePainter({this.color = Colors.black, this.strokeWidth = 6})
      : _paint = Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width * 0.5;
    double centerX = radius;
    double h = 120;
    double centerY = -h;
    double sY = 0;
    double sX = 0;

    canvas.drawLine(
      Offset(sX, sY),
      Offset(sX, sY - h),
      _paint,
    );
    canvas.drawLine(
      Offset(sX + radius * 2, sY),
      Offset(sX + radius * 2, sY - h),
      _paint,
    );
    canvas.drawLine(
      Offset(sX, sY),
      Offset(sX + radius * 2, sY),
      _paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      pi,
      pi,
      false,
      _paint,
    );

    canvas.drawLine(
      Offset(sX + radius * 0.7, sY - radius * 0.35),
      Offset(sX + radius * 0.7, sY - h - radius * 0.7),
      _paint,
    );
    canvas.drawLine(
      Offset(sX + radius + radius * 0.3, sY - radius * 0.35),
      Offset(sX + radius + radius * 0.3, sY - h - radius * 0.7),
      _paint,
    );
    canvas.drawLine(
      Offset(sX, sY - radius * 0.35),
      Offset(sX + radius * 2, sY - radius * 0.35),
      _paint,
    );

    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(centerX, centerY - radius * 0.7),
          radius: radius * 0.3),
      pi,
      pi,
      false,
      _paint,
    );

    canvas.drawLine(
      Offset(sX - radius * 0.2, sY - h * 0.5 - radius * 0.5),
      Offset(sX + radius * 2 + radius * 0.2, sY - h * 0.5 - radius * 0.5),
      _paint,
    );

    canvas.drawCircle(
      Offset(centerX, centerY - radius - radius * 0.1 - 0),
      radius * 0.1,
      _paint,
    );
  }

  @override
  bool shouldRepaint(_CagePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
