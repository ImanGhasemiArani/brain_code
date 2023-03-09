// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../strs.dart';
import '../../widgets/animated_text.dart';
import '../../widgets/movable.dart';
import 'level_obj_controller.dart';

class L1ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L1ObjController() {
    currentObj = objects['']!;
  }

  @override
  void runCommandAnim(BuildContext context, String str) {}

  @override
  void runCommandMove(BuildContext context, String str) {
    final args =
        str.split(':').last.split(',').map((e) => double.parse(e)).toList();
    currentObj.value.edit(np: Offset(args[0], -args[1]));

    currentObj.notifyListeners();
  }

  @override
  void runCommandRotate(BuildContext context, String str) {
    final arg = double.parse(str.split(':').last);
    currentObj.value.edit(nr: arg);

    currentObj.notifyListeners();
  }

  @override
  void runCommandSelect(BuildContext context, String str) {}

  @override
  void runCommandText(BuildContext context, String str) {}
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
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(100),
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
              '6',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontSize: 60),
            ),
          ),
        ],
      ),
    );
  }
}
