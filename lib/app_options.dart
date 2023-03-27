// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sounds_controller.dart';

late final SharedPreferences sp;

class AppOptions {
  static final _instance = AppOptions._internal();

  factory AppOptions() => _instance;

  AppOptions._internal()
      : runCounter = (sp.getInt('runCounter') ?? 0) + 1,
        _isVibrate = sp.getBool('isVibrate') ?? true,
        _isMute = sp.getBool('isMute') ?? false,
        _isDarkMode = sp.getBool('isDarkMode') ?? false,
        _isRecentCommandsOn = sp.getBool('isRecentCommandsOn') ?? true,
        _level = sp.getInt('level') ?? 1,
        // _level = 2,
        _recentCommands = sp.getStringList('recentCommands') ?? [],
        recentCommandNotifier = ValueNotifier<bool>(false),
        isRecentCommandOnNotifier =
            ValueNotifier<bool>(sp.getBool('isRecentCommandsOn') ?? true) {
    sp.setInt('runCounter', runCounter);
  }

  late BuildContext context;
  int runCounter;
  bool _isVibrate;
  bool _isMute;
  bool _isDarkMode;
  bool _isRecentCommandsOn;
  int _level;
  final List<String> _recentCommands;
  final ValueNotifier<bool> recentCommandNotifier;
  final ValueNotifier<bool> isRecentCommandOnNotifier;

  bool get isVibrate => _isVibrate;
  bool get isMute => _isMute;
  bool get isDarkMode => _isDarkMode;
  bool get isRecentCommandsOn => _isRecentCommandsOn;
  int get level => _level;
  List<String> get recentCommands => _recentCommands;

  set isVibrate(bool value) {
    if (_isVibrate == value) return;
    _isVibrate = value;
    sp.setBool('isVibrate', _isVibrate);

    // print('save isVibrate = $_isVibrate');
  }

  set isMute(bool value) {
    if (_isMute == value) return;
    _isMute = value;
    if (_isMute) {
      SoundsController().stop();
    } else {
      SoundsController().play();
    }
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
    isRecentCommandOnNotifier.value = _isRecentCommandsOn;
    sp.setBool('isRecentCommandsOn', _isRecentCommandsOn);

    // print('save isRecentCommandsOn = $_isRecentCommandsOn');
  }

  set level(int value) {
    if (_level >= value) return;
    _level = value;
    sp.setInt('level', _level);

    // print('save level = $_level');
  }

  set addRecentCommand(String value) {
    if (_recentCommands.contains(value)) {
      _recentCommands.remove(value);
    }
    _recentCommands.insert(0, value);
    recentCommandNotifier.notifyListeners();
    sp.setStringList('recentCommands', _recentCommands);

    // print('save recentCommands = $_recentCommands');
  }
}
