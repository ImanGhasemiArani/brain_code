// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import 'l_1.dart';
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
    final l = levels[newLevel]?.call();
    if (l == null) return;
    currentLevelObjController = l.key;
    currentLevelWidget = l.value;
    currentLevel = newLevel;
    currentLevelNotifier.value = currentLevel;
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
};
