import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:vibration/vibration.dart';

import '../app_options.dart';
import '../commands_controller.dart';
import '../models/command.dart';
import '../strs.dart';
import 'home_page.dart';

class CommandPalette extends StatefulWidget {
  const CommandPalette({super.key});

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final _controller = RichTextController(
    onMatch: (strs) {},
    patternMatchMap: {
      RegExp(r'^/(text|rotate|move|anim|select|menu|theme|level|info|restart|scan|generate|music|shop|help|about|)'):
          Theme.of(AppOptions().context).textTheme.headlineSmall!.copyWith(
                fontSize: 20,
                fontFamily: 'Inconsolata',
                color: Colors.blue.shade800,
              ),
      RegExp(r'[a-z-,0-9]+'):
          Theme.of(AppOptions().context).textTheme.headlineSmall!.copyWith(
                fontSize: 20,
                fontFamily: 'Inconsolata',
                color: Colors.tealAccent.shade700,
              ),
    },
  );

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.text.trim().isEmpty) return;
      final list = CommandsController().suggestCommands(_controller.text);
      scaffoldKey.currentState?.showBottomSheet(
        (context) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  list.length,
                  (index) => CupertinoButton(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    onPressed: () {
                      String temp = list[index] is Command
                          ? '/${list[index].name}'
                          : list[index];
                      temp =
                          temp.replaceFirst(_controller.text.split(':').last, '');
                      _controller.text = _controller.text + temp;
                      _controller.selection = TextSelection.collapsed(
                          offset: _controller.text.length);
                    },
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                                (list[index] is Command)
                                    ? '/${list[index].name}'
                                    : list[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontFamily: 'Inconsolata'))),
                        if (list[index] is Command)
                          Expanded(
                              flex: 3,
                              child: Row(children: [
                                Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text('${list[index].tip}#',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                                color: Colors.blue.shade900)))
                              ])),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        enableDrag: false,
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.6),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        constraints: const BoxConstraints(maxHeight: 150),
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommandField(_controller),
            Keyboard(_controller),
          ],
        ),
      ),
    );
  }
}

class CommandField extends StatelessWidget {
  const CommandField(this.controller, {super.key});

  final RichTextController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      autofocus: true,
      showCursor: true,
      autocorrect: false,
      enableIMEPersonalizedLearning: false,
      enableInteractiveSelection: false,
      enableSuggestions: false,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 20,
            fontFamily: 'Inconsolata',
          ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        border: InputBorder.none,
        hintText: '#${Strs.enterCommand}',
        hintStyle:
            Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
      ),
    );
  }
}

class Keyboard extends StatelessWidget {
  const Keyboard(this.controller, {super.key});

  final RichTextController controller;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      animationDuration: Duration.zero,
    );
    final tStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontFamily: 'Inconsolata',
          fontWeight: FontWeight.w500,
        );
    final rows = <Widget>[];
    for (final row in buttons) {
      final rowKeys = <Widget>[];
      for (final keyText in row) {
        final Widget child;
        final int flex;
        final void Function() onPressed;
        Function()? onLongPress;
        switch (keyText) {
          case 'clear':
            flex = 3;
            child = const Icon(Icons.backspace_rounded);
            onPressed = () => onPressedKey(context, 'clear');
            onLongPress = () => controller.clear();
            break;
          case 'space':
            flex = 8;
            child = Text('', style: tStyle);
            onPressed = () => onPressedKey(context, ' ');
            break;
          case 'run!':
            flex = 4;
            child = Text('run!', style: tStyle);
            onPressed = () => onPressedKey(context, 'run!');
            break;
          case '-':
          case '/':
            flex = 3;
            child = Text(keyText, style: tStyle);
            onPressed = () => onPressedKey(context, keyText);
            break;
          default:
            flex = 2;
            child = Text(keyText, style: tStyle);
            onPressed = () => onPressedKey(context, keyText);
            break;
        }
        rowKeys.add(
          Expanded(
            flex: flex,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: TextButton(
                  style: style.copyWith(
                    side: MaterialStateProperty.resolveWith<BorderSide?>(
                      (states) {
                        if (states.contains(MaterialState.pressed)) {
                          return BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1);
                        }
                        return null;
                      },
                    ),
                  ),
                  onPressed: () => onPressed(),
                  onLongPress: onLongPress,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: child,
                  )),
            ),
          ),
        );
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowKeys,
        ),
      );
    }
    return SizedBox(
      height: 270,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rows,
        ),
      ),
    );
  }

  void onPressedKey(BuildContext context, String text) {
    if (AppOptions().isVibrate) {
      Vibration.vibrate(duration: 15);
    }
    if (text == 'clear') {
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
      }
    } else if (text == 'run!') {
      final command = controller.text.trim();
      CommandsController().runCommand(context, command);
      controller.clear();
    } else {
      controller.text += text;
    }
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
  }
}

const List<dynamic> buttons = [
  ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
  ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
  ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
  ['/', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'clear'],
  ['-', ',', 'space', ':', 'run!'],
];
