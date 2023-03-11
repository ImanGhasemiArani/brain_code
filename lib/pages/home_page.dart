import 'package:flutter/material.dart';

import '../widgets/command_palette.dart';
import '../widgets/command_reactive_anim.dart';
import '../widgets/recent_command.dart';
import 'levels/level_controller.dart';

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
            child: ClipRRect(
              child: Scaffold(
                key: scaffoldKey,
                body: Stack(
                  children: const [
                    LevelPlaceHolder(),
                    ReactiveAnimPlaceHolder(),
                    RecentCommandPlaceHolder(),
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
