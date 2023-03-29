// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/sounds_controller.dart';

late final SharedPreferences sp;

class AppOptions {
  static final _instance = AppOptions._internal();

  factory AppOptions() => _instance;

  AppOptions._internal()
      : runCounter = (sp.getInt('runCounter') ?? 0) + 1,
        isHaveForceUpdate = sp.getBool('isHaveForceUpdate') ?? false,
        _hintCounter = sp.getInt('hintCounter') ?? 20,
        _isVibrate = sp.getBool('isVibrate') ?? true,
        _isMute = sp.getBool('isMute') ?? false,
        _isDarkMode = sp.getBool('isDarkMode') ?? false,
        _isRecentCommandsOn = sp.getBool('isRecentCommandsOn') ?? true,
        _level = sp.getInt('level') ?? 1,
        // _level = 1,
        _allowedDailyPrize = sp.getInt('allowedDailyPrize') ?? 1,
        _awardedDailyPrize = sp.getInt('awardedDailyPrize') ?? 0,
        _lastDateOpen = sp.getString('lastDateOpen'),
        _recentCommands = sp.getStringList('recentCommands') ?? [],
        recentCommandNotifier = ValueNotifier<bool>(false),
        isRecentCommandOnNotifier =
            ValueNotifier<bool>(sp.getBool('isRecentCommandsOn') ?? true) {
    sp.setInt('runCounter', runCounter);
    lastDateOpen = DateTime.now();
  }

  late BuildContext context;
  int runCounter;
  bool isHaveForceUpdate;
  int _hintCounter;
  bool _isVibrate;
  bool _isMute;
  bool _isDarkMode;
  bool _isRecentCommandsOn;
  int _level;
  int _allowedDailyPrize;
  int _awardedDailyPrize;
  String? _lastDateOpen;
  final List<String> _recentCommands;
  final ValueNotifier<bool> recentCommandNotifier;
  final ValueNotifier<bool> isRecentCommandOnNotifier;

  int get hintCounter => _hintCounter;
  bool get isVibrate => _isVibrate;
  bool get isMute => _isMute;
  bool get isDarkMode => _isDarkMode;
  bool get isRecentCommandsOn => _isRecentCommandsOn;
  int get level => _level;
  List<String> get recentCommands => _recentCommands;
  int get allowedDailyPrize => _allowedDailyPrize;
  int get awardedDailyPrize => _awardedDailyPrize;
  DateTime? get lastDateOpen => _lastDateOpen != null
      ? DateTime(
          int.parse(_lastDateOpen!.split(',')[0]),
          int.parse(_lastDateOpen!.split(',')[1]),
          int.parse(_lastDateOpen!.split(',')[2]))
      : null;

  set hintCounter(int value) {
    _hintCounter = value;
    sp.setInt('hintCounter', _hintCounter);

    // log('save hintCounter = $_hintCounter');
  }

  set isVibrate(bool value) {
    if (_isVibrate == value) return;
    _isVibrate = value;
    sp.setBool('isVibrate', _isVibrate);

    // log('save isVibrate = $_isVibrate');
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

    // log('save isMute = $_isMute');
  }

  set isDarkMode(bool value) {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    sp.setBool('isDarkMode', _isDarkMode);

    // log('save isDarkMode = $_isDarkMode');
  }

  set isRecentCommandsOn(bool value) {
    if (_isRecentCommandsOn == value) return;
    _isRecentCommandsOn = value;
    isRecentCommandOnNotifier.value = _isRecentCommandsOn;
    sp.setBool('isRecentCommandsOn', _isRecentCommandsOn);

    // log('save isRecentCommandsOn = $_isRecentCommandsOn');
  }

  set level(int value) {
    if (_level >= value) return;
    _level = value;
    sp.setInt('level', _level);

    // log('save level = $_level');
  }

  set allowedDailyPrize(int value) {
    _allowedDailyPrize = value;

    sp.setInt('allowedDailyPrize', _allowedDailyPrize);

    // log('save allowedDailyPrize = $_allowedDailyPrize');
  }

  set awardedDailyPrize(int value) {
    if (value > allowedDailyPrize) return;
    _awardedDailyPrize = value;

    sp.setInt('awardedDailyPrize', _awardedDailyPrize);

    // log('save awardedDailyPrize = $_awardedDailyPrize');
  }

  set lastDateOpen(DateTime? value) {
    if (value == null) return;
    if (lastDateOpen == null) {
      _lastDateOpen = '${value.year},${value.month},${value.day}';
      sp.setString('lastDateOpen', _lastDateOpen!);
      return;
    }
    if (value.day == lastDateOpen!.day &&
        value.month == lastDateOpen!.month &&
        value.year == lastDateOpen!.year) return;
    final temp = lastDateOpen!.add(const Duration(days: 1));
    if (value.day == temp.day &&
        value.month == temp.month &&
        value.year == temp.year) {
      allowedDailyPrize = (allowedDailyPrize + 1) % 9;
      allowedDailyPrize = allowedDailyPrize == 0 ? 1 : allowedDailyPrize;
    } else {
      allowedDailyPrize = 1;
      awardedDailyPrize = 0;
    }
    _lastDateOpen = '${value.year},${value.month},${value.day}';

    sp.setString('lastDateOpen', _lastDateOpen!);

    // log('save lastDateOpen = $_lastDateOpen');
  }

  set addRecentCommand(String value) {
    if (_recentCommands.contains(value)) {
      _recentCommands.remove(value);
    }
    _recentCommands.insert(0, value);
    recentCommandNotifier.notifyListeners();
    sp.setStringList('recentCommands', _recentCommands);

    // log('save recentCommands = $_recentCommands');
  }

  void setIsHaveForceUpdate(bool isHave) {
    if (isHaveForceUpdate == isHave) return;
    isHaveForceUpdate = isHave;
    sp.setBool('isHaveForceUpdate', isHaveForceUpdate);

    // log('save isHaveForceUpdate = $isHaveForceUpdate');
  }
}
