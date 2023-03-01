import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_options.dart';
import 'app_theme_data.dart';
import 'models/command.dart';
import 'pages/help_page.dart';
import 'pages/levels/level_controller.dart';
import 'pages/menu_page.dart';
import 'routeing.dart';
import 'strs.dart';

class CommandsController {
  static final CommandsController _instance = CommandsController._internal();

  factory CommandsController() => _instance;

  CommandsController._internal() {
    _commands = _loadCommands();
  }

  List<Command> _commands = [];

  List<Command> get commands => _commands;

  List<Command> _loadCommands() {
    return [
      Command(
        "text",
        RegExp(r'^/text:.+$'),
        Strs.commandTextDesc,
        Strs.commandTextEx,
      ),
      Command(
        'rotate',
        RegExp(r'^/rotate:-?\d+$'),
        Strs.commandRotateDesc,
        Strs.commandRotateEx,
      ),
      Command(
        'move',
        RegExp(r'^/move:-?\d+,-?\d+$'),
        Strs.commandMoveDesc,
        Strs.commandMoveEx,
      ),
      Command(
        'anim',
        RegExp(r'^/anim:(start|stop)$'),
        Strs.commandAnimDesc,
        Strs.commandAnimEx,
      ),
      Command(
        'select',
        RegExp(r'^/select.+$'),
        Strs.commandSelectDesc,
        Strs.commandSelectEx,
      ),
      Command(
        'menu',
        RegExp(r'^/menu$'),
        Strs.commandMenuDesc,
        Strs.commandMenuEx,
        run: (BuildContext context, String str) =>
            openPage(context, const MenuPage()),
      ),
      Command(
        'theme',
        RegExp(r'^/theme:(black|white)$'),
        Strs.commandThemeDesc,
        Strs.commandThemeEx,
        run: (BuildContext context, String str) {
          final theme = str.split(':').last ==
              (AppOptions().isDarkMode ? 'black' : 'white');
          if (theme) return;
          Provider.of<ThemeChangeNotifier>(context, listen: false)
              .toggleThemeMode();
        },
      ),
      Command(
        'level',
        RegExp(r'^/level:(\d+|next|previous)$'),
        Strs.commandLevelDesc,
        Strs.commandLevelEx,
      ),
      Command(
        'info',
        RegExp(r'^/info$'),
        Strs.commandInfoDesc,
        Strs.commandInfoEx,
      ),
      Command(
        'restart',
        RegExp(r'^/restart$'),
        Strs.commandRestartDesc,
        Strs.commandRestartEx,
      ),
      Command(
        'scan',
        RegExp(r'^/scan$'),
        Strs.commandScanDesc,
        Strs.commandScanEx,
      ),
      Command(
        'generate',
        RegExp(r'^/generate$'),
        Strs.commandGenerateDesc,
        Strs.commandGenerateEx,
      ),
      Command(
        'music',
        RegExp(r'^/music:(on|off)$'),
        Strs.commandMusicDesc,
        Strs.commandMusicEx,
        run: (BuildContext context, String str) {
          final isMute =
              str.split(':').last == (AppOptions().isMute ? 'off' : 'on');
          if (isMute) return;
          AppOptions().isMute = !AppOptions().isMute;
        },
      ),
      Command(
        'shop',
        RegExp(r'^/shop$'),
        Strs.commandShopDesc,
        Strs.commandShopEx,
      ),
      Command(
        'help',
        RegExp(r'^/help$'),
        Strs.commandHelpDesc,
        Strs.commandHelpEx,
        run: (BuildContext context, String str) =>
            openPage(context, const HelpPage()),
      ),
      Command(
        'about',
        RegExp(r'^/about$'),
        Strs.commandAboutDesc,
        Strs.commandAboutEx,
      ),
    ];
  }

  bool isCommandFormat(String str) {
    for (final command in _commands) {
      if (command.regExp.hasMatch(str)) return true;
    }
    return false;
  }

  void runCommand(BuildContext context, String commandStr) {
    for (final command in _commands) {
      if (command.regExp.hasMatch(commandStr)) {
        command.run?.call(context, commandStr);
        invokeMethod[command.name]?.call(context, commandStr);
        return;
      }
    }
  }

  Map<String, dynamic> invokeMethod = {
    'text': LevelController().currentLevelObjController?.runCommandText,
    'rotate': LevelController().currentLevelObjController?.runCommandRotate,
    'move': LevelController().currentLevelObjController?.runCommandMove,
    'anim': LevelController().currentLevelObjController?.runCommandAnim,
    'select': LevelController().currentLevelObjController?.runCommandSelect,
    'menu': LevelController().currentLevelObjController?.runCommandMenu,
    'theme': LevelController().currentLevelObjController?.runCommandTheme,
    'level': LevelController().currentLevelObjController?.runCommandLevel,
    'info': LevelController().currentLevelObjController?.runCommandInfo,
    'restart': LevelController().currentLevelObjController?.runCommandRestart,
    'scan': LevelController().currentLevelObjController?.runCommandScan,
    'generate': LevelController().currentLevelObjController?.runCommandGenerate,
    'music': LevelController().currentLevelObjController?.runCommandMusic,
    'shop': LevelController().currentLevelObjController?.runCommandShop,
    'help': LevelController().currentLevelObjController?.runCommandHelp,
    'about': LevelController().currentLevelObjController?.runCommandAbout,
  };
}
