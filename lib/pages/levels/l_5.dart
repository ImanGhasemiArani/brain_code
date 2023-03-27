// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../app_theme_data.dart';
import '../../strs.dart';
import '../../widgets/animated_text.dart';
import 'level_obj_controller.dart';
import 'level_widget.dart';

class L5ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L5ObjController() {
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
    return text == 'heart';
  }
}

class L5 extends StatefulWidget {
  const L5(this.controller, {super.key});

  final L5ObjController controller;

  @override
  State<L5> createState() => _L5State();
}

class _L5State extends State<L5> {
  Color? staticColor;

  @override
  Widget build(BuildContext context) {
    staticColor ??= Theme.of(context).brightness != Brightness.light
        ? AppThemeData.darkColorScheme.background
        : AppThemeData.lightColorScheme.background;
    return LevelView(
      lve: widget.controller.levelViewEnum,
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: AnimatedTextFixed(
                  Text(
                    Strs.l5S1,
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
                    Strs.l5S2.toPersianNum(),
                    textDirection: TextDirection.ltr,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
