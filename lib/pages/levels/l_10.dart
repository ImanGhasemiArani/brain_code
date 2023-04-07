// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../strs.dart';
import '../../widgets/animated_text.dart';
import 'level_obj_controller.dart';
import 'level_widget.dart';

class L10ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L10ObjController() {
    currentObj = objects['']!;
  }

  @override
  bool isLevelPassed() {
    return text == 'keep your mind open';
  }

  @override
  final List<String> hints = [
    Strs.l10Tip1,
    Strs.l10Tip2,
    Strs.l10Tip3,
    Strs.l10Tip4,
    Strs.l10Tip5,
    Strs.l10Tip6,
  ];
}

class L10 extends StatefulWidget {
  const L10(this.controller, {super.key});

  final L10ObjController controller;

  @override
  State<L10> createState() => _L10State();
}

class _L10State extends State<L10> {
  @override
  Widget build(BuildContext context) {
    return LevelView(
      lve: widget.controller.levelViewEnum,
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: AnimatedTextFixed(
                Text(
                  Strs.l10S1,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
