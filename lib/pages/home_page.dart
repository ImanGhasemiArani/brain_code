import 'package:flutter/material.dart';

import '../strs.dart';
import 'command_palette.dart';

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
              body: Center(
                child: Text(Strs.appName,
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
            ),
          ),
          const CommandPalette(),
        ],
      ),
    );
  }
}
