// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:math';

import 'package:flutter/material.dart';

import '../../app_options.dart';
import '../../routeing.dart';
import '../shutter_page.dart';
import '../../controller/level_controller.dart';
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

    checkLevelStatus();
  }

  void runCommandMove(BuildContext context, String str) {
    final args =
        str.split(':').last.split(',').map((e) => double.parse(e)).toList();
    position += Offset(args[0], -args[1]);
    currentObj.value.edit(np: Offset(args[0], -args[1]));

    currentObj.notifyListeners();

    checkLevelStatus();
  }

  void runCommandText(BuildContext context, String str) {
    // log('runCommandText');

    checkLevelStatus();
  }

  void runCommandAnim(BuildContext context, String str) {
    // log('runCommandAnim');

    checkLevelStatus();
  }

  void runCommandSelect(BuildContext context, String str) {
    final temp = objects[str.split(':').last];
    if (temp == null) return;

    currentObj = temp;

    objects.entries.forEach((element) => element.value.value.edit());

    checkLevelStatus();
  }

  void runCommandMenu(BuildContext context, String str) {
    // log('runCommandMenu');

    checkLevelStatus();
  }

  void runCommandTheme(BuildContext context, String str) {
    // log('runCommandTheme');

    checkLevelStatus();
  }

  void runCommandLevel(BuildContext context, String str) {
    // log('runCommandLevel');

    checkLevelStatus();
  }

  void runCommandInfo(BuildContext context, String str) {
    // log('runCommandInfo');

    checkLevelStatus();
  }

  void runCommandRestart(BuildContext context, String str) {
    // log('runCommandRestart');

    checkLevelStatus();
  }

  void runCommandScan(BuildContext context, String str) {
    // log('runCommandScan');

    levelViewEnum.value = LevelViewEnum.scanner;

    checkLevelStatus();
  }

  void runCommandGenerate(BuildContext context, String str) {
    // log('runCommandGenerate');

    levelViewEnum.value = LevelViewEnum.qrCode;

    checkLevelStatus();
  }

  void runCommandMusic(BuildContext context, String str) {
    // log('runCommandMusic');

    checkLevelStatus();
  }

  void runCommandShop(BuildContext context, String str) {
    // log('runCommandShop');

    checkLevelStatus();
  }

  void runCommandHelp(BuildContext context, String str) {
    // log('runCommandHelp');

    checkLevelStatus();
  }

  void runCommandAbout(BuildContext context, String str) {
    // log('runCommandAbout');

    checkLevelStatus();
  }

  bool isLevelPassed();

  void passedLevel() {
    // log('level Passed');

    Future.delayed(const Duration(milliseconds: 1500), () {
      replacePage(ShutterPage(LevelController().currentLevel));

      AppOptions().level =
          min(LevelController().currentLevel + 1, levels.length);
      LevelController().nextLevel();
    });
  }

  void checkLevelStatus() {
    isLevelPassed() ? passedLevel() : null;
  }

  int _currentHint = 0;
  set incHintNum(int inc) {
    _currentHint += inc;
    if (_currentHint < 0) _currentHint = 0;
    if (_currentHint >= hints.length) _currentHint = hints.length;
  }

  int get hint => _currentHint;

  abstract final List<String> hints;
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
