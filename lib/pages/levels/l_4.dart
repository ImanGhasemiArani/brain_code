// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../app_theme_data.dart';
import '../../strs.dart';
import '../../widgets/animated_text.dart';
import 'level_obj_controller.dart';

class L4ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L4ObjController() {
    currentObj = objects['']!;
  }

  String text = '';

  @override
  void runCommandText(BuildContext context, String str) {
    final arg = str.split(':').last;
    text = arg;

    super.runCommandText(context, str);
  }

  @override
  bool isLevelPassed() {
    return text == 'hurt';
  }
}

class L4 extends StatefulWidget {
  const L4(this.controller, {super.key});

  final L4ObjController controller;

  @override
  State<L4> createState() => _L4State();
}

class _L4State extends State<L4> {
  Color? staticColor;

  @override
  Widget build(BuildContext context) {
    staticColor ??= Theme.of(context).brightness != Brightness.light
        ? AppThemeData.darkColorScheme.background
        : AppThemeData.lightColorScheme.background;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: AnimatedTextFixed(
                Text(
                  Strs.l4S1,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.ltr,
              children: [
                Icon(Icons.location_on_rounded, color: staticColor),
                Text(
                  Strs.l4S2.toPersianNum(),
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
