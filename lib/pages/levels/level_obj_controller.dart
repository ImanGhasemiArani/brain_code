// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:math';

import 'package:flutter/material.dart';

import '../../app_options.dart';
import 'level_controller.dart';

abstract class LevelObjController {
  abstract final Map<String, ValueNotifier<ObjState>> objects;

  late ValueNotifier<ObjState> currentObj;
  double rotation = 0;
  Offset position = Offset.zero;

  ValueNotifier<ObjState> getObj(String label) => objects[label]!;

  void runCommandRotate(BuildContext context, String str) {
    final arg = double.parse(str.split(':').last);
    rotation += arg;
    currentObj.value.edit(nr: arg);

    currentObj.notifyListeners();

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandMove(BuildContext context, String str) {
    final args =
        str.split(':').last.split(',').map((e) => double.parse(e)).toList();
    position += Offset(args[0], -args[1]);
    currentObj.value.edit(np: Offset(args[0], -args[1]));

    currentObj.notifyListeners();

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandText(BuildContext context, String str) {
    print('runCommandText');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandAnim(BuildContext context, String str) {
    print('runCommandAnim');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandSelect(BuildContext context, String str) {
    print('runCommandSelect');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandMenu(BuildContext context, String str) {
    print('runCommandMenu');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandTheme(BuildContext context, String str) {
    print('runCommandTheme');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandLevel(BuildContext context, String str) {
    print('runCommandLevel');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandInfo(BuildContext context, String str) {
    print('runCommandInfo');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandRestart(BuildContext context, String str) {
    print('runCommandRestart');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandScan(BuildContext context, String str) {
    print('runCommandScan');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandGenerate(BuildContext context, String str) {
    print('runCommandGenerate');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandMusic(BuildContext context, String str) {
    print('runCommandMusic');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandShop(BuildContext context, String str) {
    print('runCommandShop');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandHelp(BuildContext context, String str) {
    print('runCommandHelp');

    isLevelPassed() ? passedLevel() : null;
  }

  void runCommandAbout(BuildContext context, String str) {
    print('runCommandAbout');

    isLevelPassed() ? passedLevel() : null;
  }

  bool isLevelPassed();

  void passedLevel() {
    print('level Passed');

    AppOptions().level = min(LevelController().currentLevel + 1, levels.length);
    LevelController().nextLevel();
  }
}

class ObjState {
  final String objLabel;
  Offset position;
  double rotation;
  bool? isAnim;
  String? text;

  ObjState(
    this.objLabel, {
    this.position = Offset.zero,
    this.rotation = 0,
    this.isAnim = false,
    this.text,
  });

  ObjState edit({Offset? np, double? nr, bool? nia, String? nt}) {
    clear();
    np == null ? null : position = np;
    nr == null ? null : rotation = nr;
    nia == null ? null : isAnim = nia;
    nt == null ? null : text = nt;
    return this;
  }

  void clear() {
    position = Offset.zero;
    rotation = 0;
    isAnim = null;
    // text = null;
  }

  @override
  String toString() {
    return 'l=$objLabel p=$position r=$rotation a=$isAnim t=$text';
  }
}
