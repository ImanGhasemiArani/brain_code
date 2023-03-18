// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';
import 'dart:math';

import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../widgets/movable.dart';
import 'level_obj_controller.dart';

class L7ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L7ObjController() {
    currentObj = objects['']!;
    isCorrectLocation = ValueNotifier(false);
  }

  bool isFirst = false;
  late final ValueNotifier<bool> isCorrectLocation;
  StreamSubscription<GyroscopeEvent>? sub;

  final key = GlobalKey();
  final staticKey = GlobalKey();

  void gyroscopeListener(GyroscopeEvent event) {
    if (sub == null) return;

    currentObj.value.edit(np: Offset(event.y * 70, event.x * 70));
    currentObj.notifyListeners();

    checkPosition();
  }

  void checkPosition() {
    try {
      final RenderBox renderBox =
          key.currentContext?.findRenderObject() as RenderBox;
      final Size size = renderBox.size;
      final Offset offset = renderBox.localToGlobal(Offset.zero);
      final pos =
          Offset(offset.dx + size.width / 2, offset.dy + size.height / 2);

      final RenderBox staticRenderBox =
          staticKey.currentContext?.findRenderObject() as RenderBox;
      final Size staticSize = staticRenderBox.size;
      final Offset staticOffset = staticRenderBox.localToGlobal(Offset.zero);
      final staticPos = Offset(staticOffset.dx + staticSize.width / 2,
          staticOffset.dy + staticSize.height / 2);

      final distance = sqrt(
          pow((staticPos.dx - pos.dx), 2) + pow((staticPos.dy - pos.dy), 2));
          
      isCorrectLocation.value = distance <= 5;
    } catch (e) {}
  }

  @override
  void runCommandAnim(BuildContext context, String str) {
    final arg = str.split(':').last == 'start' ? true : false;

    if (arg) {
      if (!isFirst) {
        isFirst = true;
        currentObj.value.edit(np: const Offset(100, -100));
        currentObj.notifyListeners();
      }

      if (sub != null) return;
      Future.delayed(const Duration(milliseconds: 100), () {
        sub = gyroscopeEvents.listen(gyroscopeListener);
      });
    } else {
      sub?.cancel();
      sub = null;
    }
    super.runCommandAnim(context, str);
  }

  @override
  void runCommandRestart(BuildContext context, String str) {
    sub?.cancel();
    sub = null;
    super.runCommandRestart(context, str);
  }

  @override
  bool isLevelPassed() {
    return false;
  }

  @override
  void passedLevel(BuildContext context) {
    sub?.cancel();
    sub = null;
    super.passedLevel(context);
  }
}

class L7 extends StatefulWidget {
  const L7(this.controller, {super.key});

  final L7ObjController controller;

  @override
  State<L7> createState() => _L7State();
}

class _L7State extends State<L7> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final r = sqrt(pow(constraints.maxHeight * 0.5 + 100, 2) +
                pow(constraints.maxWidth * 0.5 + 100, 2)) +
            100;
        return Scaffold(
          body: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: widget.controller.isCorrectLocation,
                builder: (context, value, child) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 7000),
                  top: value
                      ? constraints.maxHeight * 0.5 + 100 - 35 / 2 - r
                      : constraints.maxHeight * 0.5 + 100 - 35 / 2,
                  right: value
                      ? constraints.maxHeight * 0.5 + 100 - 35 / 2 - r
                      : constraints.maxWidth * 0.5 + 100 - 35 / 2,
                  child: Center(
                    child: AnimatedContainer(
                      onEnd: () {
                        if (value) {
                          widget.controller
                              .runCommandAnim(context, '/anim:stop');
                          widget.controller.passedLevel(context);
                        }
                      },
                      duration: const Duration(milliseconds: 7000),
                      height: value ? r * 2 : 35,
                      width: value ? r * 2 : 35,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onBackground,
                        shape: BoxShape.circle,
                      ),
                      child: child,
                    ),
                  ),
                ),
              ),
              AlignPositioned(
                dx: -100,
                dy: 100,
                child: Container(
                  key: widget.controller.staticKey,
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 3,
                        strokeAlign: 1,
                      ),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              MovableObject(
                state: widget.controller.getObj(''),
                alignment: Alignment.center,
                initPosition: const Offset(-100, 100),
                child: Container(
                  key: widget.controller.key,
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
