import 'package:flutter/material.dart';

class TextCommand extends StatelessWidget {
  const TextCommand(this.commandStr, {super.key});

  final String commandStr;

  @override
  Widget build(BuildContext context) {
    final l = commandStr.split(':');
    final tp1 = l.removeAt(0);
    final tp2 = l.isNotEmpty ? l[0] : null;
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(
            text: tp1,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontFamily: 'Inconsolata',
                ),
          ),
          if (tp2 != null)
            const TextSpan(
              text: ':',
            ),
          if (tp2 != null)
            TextSpan(
              text: tp2,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontFamily: 'Inconsolata',
                  ),
            ),
        ],
      ),
    );
  }
}
