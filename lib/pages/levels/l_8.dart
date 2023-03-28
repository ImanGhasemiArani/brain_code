// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../app_theme_data.dart';
import '../../strs.dart';
import '../../widgets/movable.dart';
import '../../widgets/qr_code_widget.dart';
import 'level_obj_controller.dart';
import 'level_widget.dart';

class L8ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L8ObjController() {
    currentObj = objects['']!;
  }

  final String qrCode = 'level 8 is completed!';

  @override
  bool isLevelPassed() {
    return scanResult == qrCode;
  }

  @override
  final List<String> hints = [
    Strs.l8Tip1,
    Strs.l8Tip2,
    Strs.l8Tip3,
    Strs.l8Tip4,
    Strs.l8Tip5
  ];
}

class L8 extends StatefulWidget {
  const L8(this.controller, {super.key});

  final L8ObjController controller;

  @override
  State<L8> createState() => _L8State();
}

class _L8State extends State<L8> {
  Color? cageColor;

  @override
  Widget build(BuildContext context) {
    cageColor ??= Theme.of(context).brightness == Brightness.light
        ? AppThemeData.lightColorScheme.background
        : AppThemeData.darkColorScheme.background;
    return LevelView(
      lve: widget.controller.levelViewEnum,
      child: Scaffold(
        body: Stack(
          children: [
            MovableObject(
              state: widget.controller.getObj(''),
              alignment: Alignment.center,
              initPosition: const Offset(0, 0),
              child: QRCodeView(
                data: widget.controller.qrCode,
                fColor: cageColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
