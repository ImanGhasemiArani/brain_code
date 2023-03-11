// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import 'l_1.dart';
import 'l_2.dart';
import 'level_obj_controller.dart';

typedef LevelBuilder = MapEntry<LevelObjController, Widget> Function();

class LevelController {
  static final _instance = LevelController._internal();

  factory LevelController() => _instance;

  LevelController._internal() : currentLevelNotifier = ValueNotifier(0);

  final ValueNotifier<int> currentLevelNotifier;

  int currentLevel = 0;
  Widget? currentLevelWidget;
  LevelObjController? currentLevelObjController;

  void setCurrentLevel(int newLevel) {
    if (newLevel < 1 || newLevel > levels.length) return;
    final l = levels[newLevel]?.call();
    if (l == null) return;
    currentLevelObjController = l.key;
    currentLevelWidget = l.value;
    currentLevel = newLevel;
    currentLevelNotifier.value = currentLevel;
  }

  void nextLevel() {
    setCurrentLevel(currentLevel + 1);
  }

  void previousLevel() {
    setCurrentLevel(currentLevel - 1);
  }

  void restartCurrentLevel() {
    setCurrentLevel(currentLevel);
    currentLevelNotifier.notifyListeners();
  }
}

final Map<int, LevelBuilder> levels = {
  1: () {
    final controller = L1ObjController();
    final level = L1(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  2: () {
    final controller = L2ObjController();
    final level = L2(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
};

class LevelPlaceHolder extends StatelessWidget {
  const LevelPlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: LevelController().currentLevelNotifier,
      builder: (context, value, child) {
        return LevelController().currentLevelWidget ?? const SizedBox.expand();
      },
    );
  }
}
