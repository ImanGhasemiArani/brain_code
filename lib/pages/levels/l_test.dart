// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../strs.dart';
import '../../widgets/movable.dart';
import 'level_obj_controller.dart';

class LTestObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    'title': ValueNotifier(ObjState('title', text: Strs.help)),
    'close-icon': ValueNotifier(ObjState('close-icon')),
  };

  LTestObjController() {
    currentObj = objects['title']!;
  }

  bool objTitleMove = false;
  bool objCloseIconMove = false;
  bool objTitleText = false;
  bool objTitleIsAnim = false;
  bool objCloseIconIsAnim = false;

  @override
  void runCommandAnim(BuildContext context, String str) {
    if (currentObj.value.objLabel == 'title') {
      if (objTitleIsAnim) {
        currentObj.value.edit(nia: false);
      } else {
        currentObj.value.edit(nia: true);
      }
      objTitleIsAnim = !objTitleIsAnim;
    } else {
      if (objCloseIconIsAnim) {
        currentObj.value.edit(nia: false);
      } else {
        currentObj.value.edit(nia: true);
      }
      objCloseIconIsAnim = !objCloseIconIsAnim;
    }

    currentObj.notifyListeners();
  }

  @override
  void runCommandMove(BuildContext context, String str) {
    if (currentObj.value.objLabel == 'title') {
      if (objTitleMove) {
        currentObj.value.edit(np: const Offset(100, 50));
      } else {
        currentObj.value.edit(np: const Offset(-100, -50));
      }
      objTitleMove = !objTitleMove;
    } else {
      if (objCloseIconMove) {
        currentObj.value
            .edit(np: Offset(MediaQuery.of(context).size.width / 2, 0));
      } else {
        currentObj.value
            .edit(np: Offset(-MediaQuery.of(context).size.width / 2, 0));
      }
      objCloseIconMove = !objCloseIconMove;
    }

    currentObj.notifyListeners();
  }

  @override
  void runCommandRotate(BuildContext context, String str) {
    currentObj.value.edit(nr: 90);

    currentObj.notifyListeners();
  }

  @override
  void runCommandSelect(BuildContext context, String str) {
    if (currentObj.value.objLabel == 'title') {
      currentObj = objects['close-icon']!;
    } else {
      currentObj = objects['title']!;
    }

    objects.entries.forEach((element) => element.value.value.edit());

    // currentObj.notifyListeners();
  }

  @override
  void runCommandText(BuildContext context, String str) {
    if (currentObj.value.objLabel == 'title') {
      if (objTitleText) {
        currentObj.value.edit(nt: 'Help');
      } else {
        currentObj.value.edit(nt: 'Hi');
      }
      objTitleText = !objTitleText;
      currentObj.notifyListeners();
    }
  }

  @override
  bool isLevelPassed() {
    throw UnimplementedError();
  }
}

class LTest extends StatelessWidget {
  const LTest(this.controller, {super.key});

  final LTestObjController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MovableObject(
            state: controller.getObj('close-icon'),
            alignment: Alignment.topRight,
            initPosition: const Offset(0, 20),
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close_rounded,
                size: 35,
              ),
            )),
        MovableObject(
          state: controller.getObj('title'),
          alignment: Alignment.bottomRight,
          initPosition: const Offset(-40, -40),
          textStyle: Theme.of(context).textTheme.headlineLarge,
          child: Text(
            Strs.help,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ],
    );
  }
}
