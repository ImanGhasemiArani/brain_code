import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'app_options.dart';
import 'pages/in_dev_page.dart';
import 'utils.dart';
import 'app_theme_data.dart';
import 'models/command.dart';
import 'pages/about_page.dart';
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
        RegExp(r'^/select:.+$'),
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
        run: (context, commandStr) => showTopSnackBar(
          Overlay.of(context),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Text(
              '${Strs.level} ${LevelController().currentLevel}'.toPersianNum(),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.background,
                  ),
            ),
          ),
          padding: const EdgeInsets.all(20),
        ),
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
        run: (BuildContext context, String str) =>
            openPage(context, const InDevPage()),
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
        run: (BuildContext context, String str) =>
            openPage(context, const AboutPage()),
      ),
    ];
  }

  List<String> suggestCommands(String str) {
    final result = <String>[];
    if (str.startsWith('/') && str.contains(':')) {
      final command = str.split(':').first.replaceAll('/', '');
      final commandArgs = str.split(':').last;
      final commandsPredict = {
        'theme': ['black', 'white'],
        'music': ['on', 'off'],
        'anim': ['start', 'stop'],
        'level': ['next', 'previous'] +
            List.generate(AppOptions().level, (index) => '${index + 1}'),
        'select': LevelController()
                .currentLevelObjController
                ?.objects
                .keys
                .toList() ??
            [],
      };
      if (commandsPredict.containsKey(command)) {
        for (final arg in commandsPredict[command]!) {
          if (arg.startsWith(commandArgs) && arg != commandArgs) {
            result.add('/$command:$arg');
          }
        }
      }
    }
    for (final command in _commands) {
      if ('/${command.name}'.startsWith(str) && '/${command.name}' != str) {
        if ([
          'text',
          'rotate',
          'move',
          'anim',
          'select',
          'music',
          'level',
          'theme'
        ].contains(command.name)) {
          result.add('/${command.name}:');
          continue;
        }
        result.add('/${command.name}');
      }
    }
    return result;
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
