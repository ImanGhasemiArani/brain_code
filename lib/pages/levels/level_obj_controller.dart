import 'package:flutter/material.dart';

abstract class LevelObjController {
  abstract final Map<String, ValueNotifier<ObjState>> objects;

  late ValueNotifier<ObjState> currentObj;

  ValueNotifier<ObjState> getObj(String label) => objects[label]!;

  void runCommandText(BuildContext context, String str);

  void runCommandRotate(BuildContext context, String str);

  void runCommandMove(BuildContext context, String str);

  void runCommandAnim(BuildContext context, String str);

  void runCommandSelect(BuildContext context, String str);

  void runCommandMenu(BuildContext context, String str) {
    print('runCommandMenu');
  }

  void runCommandTheme(BuildContext context, String str) {
    print('runCommandTheme');
  }

  void runCommandLevel(BuildContext context, String str) {
    print('runCommandLevel');
  }

  void runCommandInfo(BuildContext context, String str) {
    print('runCommandInfo');
  }

  void runCommandRestart(BuildContext context, String str) {
    print('runCommandRestart');
  }

  void runCommandScan(BuildContext context, String str) {
    print('runCommandScan');
  }

  void runCommandGenerate(BuildContext context, String str) {
    print('runCommandGenerate');
  }

  void runCommandMusic(BuildContext context, String str) {
    print('runCommandMusic');
  }

  void runCommandShop(BuildContext context, String str) {
    print('runCommandShop');
  }

  void runCommandHelp(BuildContext context, String str) {
    print('runCommandHelp');
  }

  void runCommandAbout(BuildContext context, String str) {
    print('runCommandAbout');
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
