import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sp;

class AppOptions {
  static final _instance = AppOptions._internal();

  factory AppOptions() => _instance;

  AppOptions._internal()
      : _isVibrate = sp.getBool('isVibrate') ?? true,
        _isMute = sp.getBool('isMute') ?? false,
        _isDarkMode = sp.getBool('isDarkMode') ?? false,
        _isRecentCommandsOn = sp.getBool('isRecentCommandsOn') ?? true,
        _level = sp.getInt('level') ?? 1;

  late BuildContext context;
  bool _isVibrate;
  bool _isMute;
  bool _isDarkMode;
  bool _isRecentCommandsOn;
  int _level;

  bool get isVibrate => _isVibrate;
  bool get isMute => _isMute;
  bool get isDarkMode => _isDarkMode;
  bool get isRecentCommandsOn => _isRecentCommandsOn;
  int get level => _level;

  set isVibrate(bool value) {
    if (_isVibrate == value) return;
    _isVibrate = value;
    sp.setBool('isVibrate', _isVibrate);

    // print('save isVibrate = $_isVibrate');
  }

  set isMute(bool value) {
    if (_isMute == value) return;
    _isMute = value;
    sp.setBool('isMute', _isMute);

    // print('save isMute = $_isMute');
  }

  set isDarkMode(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    sp.setBool('isDarkMode', _isDarkMode);

    // print('save isDarkMode = $_isDarkMode');
  }

  set isRecentCommandsOn(bool value) {
    if (_isRecentCommandsOn == value) return;
    _isRecentCommandsOn = value;
    sp.setBool('isRecentCommandsOn', _isRecentCommandsOn);

    // print('save isRecentCommandsOn = $_isRecentCommandsOn');
  }

  set level(int value) {
    if (_level >= value) return;
    _level = value;
    sp.setInt('level', _level);

    // print('save level = $_level');
  }
}
