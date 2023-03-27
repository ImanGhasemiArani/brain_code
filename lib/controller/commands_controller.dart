// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../app_options.dart';
import '../pages/in_dev_page.dart';
import '../utils/utils.dart';
import '../app_theme_data.dart';
import '../models/command.dart';
import '../pages/about_page.dart';
import '../pages/help_page.dart';
import 'level_controller.dart';
import '../pages/menu_page.dart';
import '../routeing.dart';
import '../strs.dart';

typedef CommandRunner = void Function(BuildContext context, String str);

class CommandsController {
  static final CommandsController _instance = CommandsController._internal();

  factory CommandsController() => _instance;

  CommandsController._internal() {
    _commands = _loadCommands();
  }

  final ValueNotifier<bool?> reactiveAnimController = ValueNotifier(null);

  List<Command> _commands = [];

  List<Command> get commands => _commands;

  List<Command> _loadCommands() {
    return [
      Command(
        "text",
        RegExp(r'^/text:.+$'),
        Strs.commandTextDesc,
        Strs.commandTextEx,
        Strs.commandTextTip,
        run: (context, commandStr) {
          final text = commandStr.split(':').last;
          if (text == 'casper') {
            AppOptions().level =
                min(LevelController().currentLevel + 1, levels.length);
            LevelController().nextLevel();
          }
        },
      ),
      Command(
        'rotate',
        RegExp(r'^/rotate:-?\d+$'),
        Strs.commandRotateDesc,
        Strs.commandRotateEx,
        Strs.commandRotateTip,
      ),
      Command(
        'move',
        RegExp(r'^/move:-?\d+,-?\d+$'),
        Strs.commandMoveDesc,
        Strs.commandMoveEx,
        Strs.commandMoveTip,
      ),
      Command(
        'anim',
        RegExp(r'^/anim:(start|stop)$'),
        Strs.commandAnimDesc,
        Strs.commandAnimEx,
        Strs.commandAnimTip,
      ),
      Command(
        'select',
        RegExp(r'^/select:.+$'),
        Strs.commandSelectDesc,
        Strs.commandSelectEx,
        Strs.commandSelectTip,
      ),
      Command(
        'menu',
        RegExp(r'^/menu$'),
        Strs.commandMenuDesc,
        Strs.commandMenuEx,
        Strs.commandMenuTip,
        run: (BuildContext context, String str) => openPage(const MenuPage()),
      ),
      Command(
        'theme',
        RegExp(r'^/theme:(black|white)$'),
        Strs.commandThemeDesc,
        Strs.commandThemeEx,
        Strs.commandThemeTip,
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
        Strs.commandLevelTip,
        run: (BuildContext context, String str) {
          final level = str.split(':').last;
          if (level == 'next') {
            LevelController().nextLevel();
          } else if (level == 'previous') {
            LevelController().previousLevel();
          } else {
            LevelController().setCurrentLevel(int.parse(level));
          }
        },
      ),
      Command(
        'info',
        RegExp(r'^/info$'),
        Strs.commandInfoDesc,
        Strs.commandInfoEx,
        Strs.commandInfoTip,
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
        Strs.commandRestartTip,
        run: (context, commandStr) => LevelController().restartCurrentLevel(),
      ),
      Command(
        'scan',
        RegExp(r'^/scan$'),
        Strs.commandScanDesc,
        Strs.commandScanEx,
        Strs.commandScanTip,
      ),
      Command(
        'generate',
        RegExp(r'^/generate$'),
        Strs.commandGenerateDesc,
        Strs.commandGenerateEx,
        Strs.commandGenerateTip,
      ),
      Command(
        'music',
        RegExp(r'^/music:(on|off)$'),
        Strs.commandMusicDesc,
        Strs.commandMusicEx,
        Strs.commandMusicTip,
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
        Strs.commandShopTip,
        run: (BuildContext context, String str) => openPage(const InDevPage()),
      ),
      Command(
        'help',
        RegExp(r'^/help$'),
        Strs.commandHelpDesc,
        Strs.commandHelpEx,
        Strs.commandHelpTip,
        run: (BuildContext context, String str) => openPage(const HelpPage()),
      ),
      Command(
        'about',
        RegExp(r'^/about$'),
        Strs.commandAboutDesc,
        Strs.commandAboutEx,
        Strs.commandAboutTip,
        run: (BuildContext context, String str) => openPage(const AboutPage()),
      ),
    ];
  }

  List<dynamic> suggestCommands(String str) {
    final result = [];
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
            result.add(arg);
          }
        }
      }
    }
    for (final command in _commands) {
      if ('/${command.name}'.startsWith(str) && '/${command.name}' != str) {
        result.add(command);
      }
    }
    return result;
  }

  Command? isCommandFormat(String str) {
    for (final command in _commands) {
      if (command.regExp.hasMatch(str)) return command;
    }
    return null;
  }

  Future<void> runCommand(BuildContext context, String commandStr) async {
    final command = isCommandFormat(commandStr);
    if (command == null) {
      showReactiveAnim(false);
      return;
    }

    showReactiveAnim(true);
    await Future.delayed(const Duration(milliseconds: 200));
    command.run?.call(context, commandStr);
    invokeMethod[command.name]?.call(context, commandStr);

    AppOptions().addRecentCommand = '/${command.name}';
  }

  void showReactiveAnim(bool? value) {
    reactiveAnimController.value = value;
  }

  Map<String, CommandRunner> invokeMethod = {
    'text': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandText(context, str),
    'rotate': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandRotate(context, str),
    'move': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandMove(context, str),
    'anim': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandAnim(context, str),
    'select': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandSelect(context, str),
    'menu': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandMenu(context, str),
    'theme': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandTheme(context, str),
    'level': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandLevel(context, str),
    'info': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandInfo(context, str),
    'restart': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandRestart(context, str),
    'scan': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandScan(context, str),
    'generate': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandGenerate(context, str),
    'music': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandMusic(context, str),
    'shop': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandShop(context, str),
    'help': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandHelp(context, str),
    'about': (context, str) => LevelController()
        .currentLevelObjController
        ?.runCommandAbout(context, str),
  };
}
