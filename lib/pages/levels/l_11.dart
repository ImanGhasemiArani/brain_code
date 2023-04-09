// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../app_options.dart';
import '../../strs.dart';
import '../../widgets/animated_text.dart';
import 'level_obj_controller.dart';
import 'level_widget.dart';

class L11ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L11ObjController() {
    currentObj = objects['']!;

    if (AppOptions().l11Step == 'null') {
      AppOptions().runCounter = 5;
      AppOptions().l11Step = 'start';
    } else if (AppOptions().runCounter == 6) {
      AppOptions().l11Step = 'co1';
    } else if (AppOptions().runCounter == 7) {
      AppOptions().l11Step = 'co2';
    } else if (AppOptions().runCounter == 8) {
      AppOptions().l11Step = 'co3';
    } else if (AppOptions().runCounter == 1001) {
      AppOptions().l11Step = 'co4';
    } else if (AppOptions().runCounter == 1002) {
      AppOptions().l11Step = 'co5';
    } else if (AppOptions().runCounter == 1003) {
      AppOptions().l11Step = 'finish';
    } else if (AppOptions().l11Step == 'p9') {
      AppOptions().runCounter = 1000;
    }
  }

  @override
  void runCommandRestart(BuildContext context, String str) {
    AppOptions().l11Step = 'null';
    super.runCommandRestart(context, str);
  }

  @override
  bool isLevelPassed() {
    return false;
  }

  @override
  final List<String> hints = [Strs.l11Tip1];
}

class L11 extends StatefulWidget {
  const L11(this.controller, {super.key});

  final L11ObjController controller;

  @override
  State<L11> createState() => _L11State();
}

class _L11State extends State<L11> {
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
                  () {
                    switch (AppOptions().l11Step) {
                      case 'start':
                        return Strs.l11S1;
                      case 'co1':
                        return Strs.l11S2;
                      case 'co2':
                        return Strs.l11S3;
                      case 'co3':
                        return Strs.l11S4;
                      case 'p9':
                        return Strs.l11S5;
                      case 'co4':
                        return Strs.l11S6;
                      case 'co5':
                        return Strs.l11S7;
                      case 'finish':
                        Future.delayed(const Duration(milliseconds: 1000),
                            () => widget.controller.passedLevel());
                        return Strs.l11S8;
                      default:
                        AppOptions().runCounter = 5;
                        AppOptions().l11Step = 'start';
                        return Strs.l11S1;
                    }
                  }(),
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
