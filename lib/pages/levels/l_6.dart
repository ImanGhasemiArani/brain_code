// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, import_of_legacy_library_into_null_safe

import 'package:catex/catex.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../strs.dart';
import '../../widgets/animated_text.dart';
import 'level_obj_controller.dart';
import 'level_widget.dart';

class L6ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L6ObjController() {
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

class L6 extends StatefulWidget {
  const L6(this.controller, {super.key});

  final L6ObjController controller;

  @override
  State<L6> createState() => _L6State();
}

class _L6State extends State<L6> {
  Color? staticColor;

  @override
  Widget build(BuildContext context) {
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
                    Strs.l6S1,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
            Center(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headlineLarge!,
                child: CaTeX(Strs.l6S2.toPersianNum()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
