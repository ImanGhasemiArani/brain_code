import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences sp;

class AppOptions {
  static final _instance = AppOptions._internal();

  factory AppOptions() => _instance;

  AppOptions._internal()
      : _isDarkMode = sp.getBool('isDarkMode') ?? false,
        _isRecentCommandsOn = sp.getBool('isRecentCommandsOn') ?? true,
        _level = sp.getInt('level') ?? 1;

  bool _isDarkMode;
  bool _isRecentCommandsOn;
  int _level;

  bool get isDarkMode => _isDarkMode;
  bool get isRecentCommandsOn => _isRecentCommandsOn;
  int get level => _level;

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
