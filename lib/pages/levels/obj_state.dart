import 'package:flutter/material.dart';

class ObjState {
  final String objLabel;
  Offset position;
  double rotation;
  bool isAnim;
  String? text;

  ObjState(
    this.objLabel, {
    this.position = Offset.zero,
    this.rotation = 0,
    this.isAnim = false,
    this.text,
  });

  ObjState edit({Offset? np, double? nr, bool? nia, String? nt}) {
    position = np ?? Offset.zero;
    rotation = nr ?? 0;
    isAnim = nia ?? isAnim;
    text = nt ?? text;
    return this;
  }
}
