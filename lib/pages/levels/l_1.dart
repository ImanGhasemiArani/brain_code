// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../strs.dart';
import '../../widgets/animated_text.dart';
import '../../widgets/movable.dart';
import 'level_obj_controller.dart';
import 'level_widget.dart';

class L1ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L1ObjController() {
    currentObj = objects['']!;
  }

  @override
  bool isLevelPassed() {
    return rotation % 360 == 180;
  }

  @override
  final List<String> hints = [Strs.l1Tip1, Strs.l1Tip2];
}

class L1 extends StatefulWidget {
  const L1(this.controller, {super.key});

  final L1ObjController controller;

  @override
  State<L1> createState() => _L1State();
}

class _L1State extends State<L1> {
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
                    Strs.l1S1,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
            MovableObject(
              state: widget.controller.getObj(''),
              alignment: Alignment.center,
              initPosition: const Offset(0, 0),
              child: Text(
                '9',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontSize: 60),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
