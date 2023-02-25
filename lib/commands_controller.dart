import 'models/command.dart';
import 'strs.dart';

class CommandsController {
  static final CommandsController _instance = CommandsController._fromJson();

  factory CommandsController() => _instance;

  CommandsController._fromJson() {
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
      ),
      Command(
        'rotate',
        RegExp(r'^/rotate:-?\d+$'),
        Strs.commandRotateDesc,
      ),
      Command(
        'move',
        RegExp(r'^/move:-?\d+,-?\d+$'),
        Strs.commandMoveDesc,
      ),
      Command(
        'anim',
        RegExp(r'^/anim:(start|stop)$'),
        Strs.commandAnimDesc,
      ),
      Command(
        'select',
        RegExp(r'^/select.+$'),
        Strs.commandSelectDesc,
      ),
      Command(
        'menu',
        RegExp(r'^/menu$'),
        Strs.commandMenuDesc,
      ),
      Command(
        'theme',
        RegExp(r'^/theme:(black|white)$'),
        Strs.commandThemeDesc,
      ),
      Command(
        'level',
        RegExp(r'^/level:(\d+|next|previous)$'),
        Strs.commandLevelDesc,
      ),
      Command(
        'info',
        RegExp(r'^/info$'),
        Strs.commandInfoDesc,
      ),
      Command(
        'restart',
        RegExp(r'^/restart$'),
        Strs.commandRestartDesc,
      ),
      Command(
        'scan',
        RegExp(r'^/scan$'),
        Strs.commandScanDesc,
      ),
      Command(
        'generate',
        RegExp(r'^/generate$'),
        Strs.commandGenerateDesc,
      ),
      Command(
        'music',
        RegExp(r'^/music:(on|off)$'),
        Strs.commandMusicDesc,
      ),
      Command(
        'shop',
        RegExp(r'^/shop$'),
        Strs.commandShopDesc,
      ),
      Command(
        'help',
        RegExp(r'^/help$'),
        Strs.commandHelpDesc,
      ),
      Command(
        'about',
        RegExp(r'^/about$'),
        Strs.commandAboutDesc,
      ),
    ];
  }
}
