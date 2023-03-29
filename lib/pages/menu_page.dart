import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routeing.dart';
import '../utils/utils.dart';
import '../app_options.dart';
import '../app_theme_data.dart';
import '../strs.dart';
import '../widgets/close_button.dart';
import 'about_page.dart';
import 'help_page.dart';
import 'in_dev_page.dart';
import '../controller/level_controller.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CloseBtn(),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ':${Strs.menu}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 20),
                _buildIconsItem(context),
                _buildMenuItem(
                    context, Strs.shop, () => openPage(const InDevPage())),
                _buildMenuItem(context, Strs.dailyPrize, openDailyPrize),
                _buildThemeItem(context),
                _buildRecentCommandsItem(context),
                _buildLevelItem(context),
                _buildMenuItem(
                    context, Strs.help, () => openPage(const HelpPage())),
                _buildMenuItem(
                    context, Strs.about, () => openPage(const AboutPage())),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconsItem(BuildContext context) => Row(
        children: [
          const SizedBox(width: 8),
          StatefulBuilder(
            builder: (context, setSate) => IconButton(
              onPressed: () => setSate(
                () => AppOptions().isVibrate = !AppOptions().isVibrate,
              ),
              icon: Icon(
                AppOptions().isVibrate
                    ? Icons.vibration_rounded
                    : Icons.mobile_off_rounded,
                size: 30,
              ),
            ),
          ),
          StatefulBuilder(
            builder: (context, setSate) => IconButton(
              onPressed: () => setSate(
                () => AppOptions().isMute = !AppOptions().isMute,
              ),
              icon: Icon(
                AppOptions().isMute
                    ? CupertinoIcons.speaker_slash_fill
                    : CupertinoIcons.speaker_3_fill,
                size: 30,
              ),
            ),
          ),
        ],
      );

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
    int level = LevelController().currentLevel;
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
                    if (level >= AppOptions().level) return;
                    level++;
                    LevelController().setCurrentLevel(level);
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
                    if (level <= 1) return;
                    level--;
                    LevelController().setCurrentLevel(level);
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
