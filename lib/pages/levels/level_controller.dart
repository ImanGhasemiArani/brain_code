import 'package:flutter/material.dart';

import 'level_obj_controller.dart';

class LevelController {
  static final _instance = LevelController._internal();

  factory LevelController() => _instance;

  LevelController._internal();

  int? currentLevel = 1;
  Widget? currentLevelWidget;
  LevelObjController? currentLevelObjController;
}
