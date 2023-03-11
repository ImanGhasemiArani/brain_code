import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_options.dart';
import '../routeing.dart';

class RecentCommand extends StatelessWidget {
  const RecentCommand({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 150,
      child: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: AppOptions().recentCommandNotifier,
            builder: (context, value, child) => ListView.builder(
              reverse: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Row(
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: CupertinoButton.filled(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          borderRadius: BorderRadius.circular(10),
                          onPressed: () {
                            try {
                              if (paletteController == null) return;
                              paletteController!.text =
                                  '${AppOptions().recentCommands[index]}${'text rotate move anim select music level theme'.contains(AppOptions().recentCommands[index].replaceAll('/', '')) ? ':' : ''}';
                              paletteController!.selection =
                                  TextSelection.collapsed(
                                      offset: paletteController!.text.length);
                            } catch (e) {}
                          },
                          minSize: 0,
                          child: Text(
                            AppOptions().recentCommands[index],
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontFamily: 'Inconsolata',
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: AppOptions().recentCommands.length,
            ),
          ),
          IgnorePointer(
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.background,
                    Theme.of(context).colorScheme.background.withOpacity(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentCommandPlaceHolder extends StatelessWidget {
  const RecentCommandPlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppOptions().isRecentCommandOnNotifier,
      builder: (context, value, child) => value
          ? const Align(
              alignment: Alignment.bottomRight,
              child: RecentCommand(),
            )
          : const SizedBox.shrink(),
    );
  }
}
