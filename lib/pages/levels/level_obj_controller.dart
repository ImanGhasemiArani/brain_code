// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:math';

import 'package:flutter/material.dart';

import '../../app_options.dart';
import '../../routeing.dart';
import '../shutter_page.dart';
import 'level_controller.dart';
import 'level_widget.dart';

abstract class LevelObjController {
  abstract final Map<String, ValueNotifier<ObjState>> objects;

  late ValueNotifier<ObjState> currentObj;
  final ValueNotifier<LevelViewEnum> levelViewEnum =
      ValueNotifier(LevelViewEnum.none);
  double rotation = 0;
  Offset position = Offset.zero;
  String? scanResult;

  ValueNotifier<ObjState> getObj(String label) => objects[label]!;

  void runCommandRotate(BuildContext context, String str) {
    final arg = double.parse(str.split(':').last);
    rotation += arg;
    currentObj.value.edit(nr: arg);

    currentObj.notifyListeners();

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandMove(BuildContext context, String str) {
    final args =
        str.split(':').last.split(',').map((e) => double.parse(e)).toList();
    position += Offset(args[0], -args[1]);
    currentObj.value.edit(np: Offset(args[0], -args[1]));

    currentObj.notifyListeners();

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandText(BuildContext context, String str) {
    print('runCommandText');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandAnim(BuildContext context, String str) {
    print('runCommandAnim');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandSelect(BuildContext context, String str) {
    final temp = objects[str.split(':').last];
    if (temp == null) return;

    currentObj = temp;

    objects.entries.forEach((element) => element.value.value.edit());

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandMenu(BuildContext context, String str) {
    print('runCommandMenu');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandTheme(BuildContext context, String str) {
    print('runCommandTheme');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandLevel(BuildContext context, String str) {
    print('runCommandLevel');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandInfo(BuildContext context, String str) {
    print('runCommandInfo');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandRestart(BuildContext context, String str) {
    print('runCommandRestart');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandScan(BuildContext context, String str) {
    print('runCommandScan');

    levelViewEnum.value = LevelViewEnum.scanner;

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandGenerate(BuildContext context, String str) {
    print('runCommandGenerate');

    levelViewEnum.value = LevelViewEnum.qrCode;

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandMusic(BuildContext context, String str) {
    print('runCommandMusic');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandShop(BuildContext context, String str) {
    print('runCommandShop');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandHelp(BuildContext context, String str) {
    print('runCommandHelp');

    isLevelPassed() ? passedLevel(context) : null;
  }

  void runCommandAbout(BuildContext context, String str) {
    print('runCommandAbout');

    isLevelPassed() ? passedLevel(context) : null;
  }

  bool isLevelPassed();

  void passedLevel(BuildContext context) {
    print('level Passed');

    Future.delayed(const Duration(milliseconds: 1500), () {
      replacePage(context, ShutterPage(LevelController().currentLevel));

      AppOptions().level =
          min(LevelController().currentLevel + 1, levels.length);
      LevelController().nextLevel();
    });
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
