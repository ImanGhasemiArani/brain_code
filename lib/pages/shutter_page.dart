import 'package:flutter/material.dart';

import '../routeing.dart';
import 'home_page.dart';

class ShutterPage extends StatelessWidget {
  const ShutterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 150),
          child: TextButton(
            onPressed: () {
              replacePage(context, const HomePage(), b: const Offset(1, 0));
            },
            child: Text(
              'مرحله بعد',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ),
    );
  }
}
