import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';
import '../app_options.dart';
import '../app_theme_data.dart';
import '../strs.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close_rounded,
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoButton(
                  onPressed: () {},
                  child: Text(
                    Strs.menu,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                _buildMenuItem(context, Strs.shop, () {}),
                _buildMenuItem(context, Strs.dailyPrize, () {}),
                _buildThemeItem(context),
                _buildRecentCommandsItem(context),
                _buildLevelItem(context),
                _buildMenuItem(context, Strs.help, () {}),
                _buildMenuItem(context, Strs.about, () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
          BuildContext context, String title, Function()? onPressed) =>
      CupertinoButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );

  Widget _buildThemeItem(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Provider.of<ThemeChangeNotifier>(context, listen: false)
            .toggleThemeMode();
      },
      child: Row(
        children: [
          Text(
            '${Strs.theme}:    ',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            Provider.of<ThemeChangeNotifier>(context).themeMode ==
                    ThemeMode.dark
                ? Strs.dark
                : Strs.light,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCommandsItem(BuildContext context) {
    bool isOn = AppOptions().isRecentCommandsOn;
    return StatefulBuilder(
      builder: (context, setState) => CupertinoButton(
        onPressed: () => setState(() {
          isOn = !isOn;
          AppOptions().isRecentCommandsOn = isOn;
        }),
        child: Row(
          children: [
            Text(
              '${Strs.recentCommands}:    ',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              isOn ? Strs.on : Strs.off,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelItem(BuildContext context) {
    int level = AppOptions().level;
    return Row(
      children: [
        const SizedBox(width: 16),
        Text(
          '${Strs.level}:    ',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return Row(
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    if (level < AppOptions().level) level++;
                  }),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Text(
                  '$level'.toPersianNum(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                IconButton(
                  onPressed: () => setState(() {
                    if (level > 1) level--;
                  }),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}