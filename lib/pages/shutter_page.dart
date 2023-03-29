// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../app_options.dart';
import '../utils/utils.dart';
import '../routeing.dart';
import '../strs.dart';
import '../widgets/hint_widget.dart';
import 'home_page.dart';
import '../controller/level_controller.dart';

class ShutterPage extends StatelessWidget {
  const ShutterPage(this.levelNum, {super.key});

  final int levelNum;

  @override
  Widget build(BuildContext context) {
    if (levelNum >= AppOptions().level - 1) {
      AppOptions().hintCounter += 1;
    }
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
              if (levelNum >= AppOptions().level - 1)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HintWidget(
                        counter: 1,
                        size: 50,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: null,
                              child: Row(
                                children: const [
                                  HintWidget(counter: 3, size: 50),
                                  Icon(Icons.drag_handle_rounded),
                                  Icon(Icons.movie_creation_rounded, size: 50),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return levelNum != levelCounter
                            ? TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () {
                                  replacePage(const HomePage(),
                                      b: const Offset(-1, 0));
                                },
                                child: Text(
                                  Strs.nextLevel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                        fontSize: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
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
