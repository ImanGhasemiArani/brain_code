import 'package:flutter/material.dart';

import 'level_obj_controller.dart';

class LevelController {
  static final _instance = LevelController._internal();

  factory LevelController() => _instance;

  LevelController._internal();

  Widget? currentLevelWidget;
  LevelObjController? currentLevelObjController;
}
