import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../strs.dart';

class CommandPalette extends StatefulWidget {
  const CommandPalette({super.key});

  @override
  State<CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<CommandPalette> {
  final _controller = TextEditingController();

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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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

  final TextEditingController controller;

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
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
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

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      foregroundColor: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    );
    final tStyle = Theme.of(context).textTheme.bodyMedium;
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
            onPressed = () => onPressedKey('clear');
            onLongPress = () => controller.clear();
            break;
          case 'space':
            flex = 8;
            child = Text('', style: tStyle);
            onPressed = () => onPressedKey(' ');
            break;
          case 'run!':
            flex = 4;
            child = Text('run!', style: tStyle);
            onPressed = () {};
            break;
          case '-':
          case '/':
            flex = 3;
            child = Text(keyText, style: tStyle);
            onPressed = () => onPressedKey(keyText);
            break;
          default:
            flex = 2;
            child = Text(keyText, style: tStyle);
            onPressed = () => onPressedKey(keyText);
            break;
        }
        rowKeys.add(
          Expanded(
            flex: flex,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: TextButton(
                  style: style.copyWith(
                    animationDuration: Duration.zero,
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

  void onPressedKey(String text) {
    Vibration.vibrate(duration: 25);
    if (text == 'clear') {
      if (controller.text.isNotEmpty) {
        controller.text =
            controller.text.substring(0, controller.text.length - 1);
      }
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
