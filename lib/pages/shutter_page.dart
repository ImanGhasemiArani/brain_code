// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../utils.dart';
import '../routeing.dart';
import '../strs.dart';
import '../widgets/hint_widget.dart';
import 'home_page.dart';
import 'levels/level_controller.dart';

class ShutterPage extends StatelessWidget {
  const ShutterPage(this.levelNum, {super.key});

  final int levelNum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    '${Strs.level} $levelNum ${Strs.completed}'.toPersianNum(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: const HintWidget(
                  counter: 1,
                  size: 50,
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: levelNum != levelCounter
                      ? TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            replacePage(context, const HomePage(),
                                b: const Offset(-1, 0));
                          },
                          child: Text(
                            Strs.nextLevel,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontSize: 25,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        )
                      : Text(
                          Strs.endLevels,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontSize: 25,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
