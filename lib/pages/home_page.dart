import 'package:flutter/material.dart';

import '../app_options.dart';
import '../routeing.dart';
import '../widgets/command_palette.dart';
import '../widgets/command_reactive_anim.dart';
import '../widgets/hint_widget.dart';
import '../widgets/recent_command.dart';
import 'help_page.dart';
import '../controller/level_controller.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
bool isOpenTutorial = AppOptions().runCounter != 1;
bool isOpenedDailyPrize =
    AppOptions().allowedDailyPrize == AppOptions().awardedDailyPrize;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!isOpenTutorial) {
      isOpenTutorial = true;
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (AppOptions().runCounter == 1) {
          openPage(const HelpPage());
        }
      });
    }
    if (!isOpenedDailyPrize) {
      isOpenedDailyPrize = true;
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (AppOptions().allowedDailyPrize != AppOptions().awardedDailyPrize) {
          openDailyPrize();
        }
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              child: Scaffold(
                key: scaffoldKey,
                body: Stack(
                  children: const [
                    LevelPlaceHolder(),
                    ReactiveAnimPlaceHolder(),
                    RecentCommandPlaceHolder(),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: HintButton(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const CommandPalette(),
        ],
      ),
    );
  }
}
