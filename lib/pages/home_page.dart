import 'package:flutter/material.dart';

import '../app_options.dart';
import '../strs.dart';
import '../widgets/command_palette.dart';
import '../widgets/recent_command.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Scaffold(
              key: scaffoldKey,
              body: Stack(
                children: [
                  Center(
                    child: Text(Strs.appName,
                        style: Theme.of(context).textTheme.headlineLarge),
                  ),
                  ValueListenableBuilder(
                    valueListenable: AppOptions().isRecentCommandOnNotifier,
                    builder: (context, value, child) => value
                        ? const Align(
                            alignment: Alignment.bottomRight,
                            child: RecentCommand(),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          const CommandPalette(),
        ],
      ),
    );
  }
}
