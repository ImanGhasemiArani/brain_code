// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

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
  void runCommandMove(BuildContext context, String str) {}

  @override
  void runCommandRotate(BuildContext context, String str) {
    final arg = int.parse(str.split(':').last);
    currentObj.value.edit(nr: arg.toDouble());

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
    return Stack(
      children: [
        MovableObject(
          state: widget.controller.getObj(''),
          alignment: Alignment.bottomCenter,
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
    );
  }
}
