import 'package:flutter/material.dart';

import 'command_palette.dart';
import 'menu_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      transitionsBuilder: (context, anim1, anim2, child) =>
                          SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(anim1),
                        child: child,
                      ),
                      pageBuilder: (context, anim1, anim2) => const MenuPage(),
                    ),
                  );
                },
                child: const Text('open Menu'),
              ),
            ),
          ),
          const CommandPalette(),
        ],
      ),
    );
  }
}