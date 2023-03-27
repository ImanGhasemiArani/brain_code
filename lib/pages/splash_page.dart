import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../controller/api_controller.dart';
import '../routeing.dart';
import '../strs.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    APIController().checkVersion().then((value) {
      if (value == null) return;
      showUpdateDialog(value);
    });
    super.initState();
  }

  bool isP1Finished = false;
  bool isP2Finished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  speed: const Duration(milliseconds: 100),
                  Strs.appName.split(':').first,
                  textStyle:
                      Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontSize: 40,
                          ),
                  cursor: '|',
                ),
              ],
              isRepeatingAnimation: false,
              onFinished: () {
                setState(() {
                  isP1Finished = true;
                });
              },
            ),
            if (isP1Finished)
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 2000),
                switchInCurve: Curves.ease,
                child: !isP2Finished
                    ? AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            speed: const Duration(milliseconds: 100),
                            ' : ${Strs.appName.split(':').last}',
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  fontSize: 40,
                                ),
                            cursor: '|',
                          ),
                        ],
                        isRepeatingAnimation: false,
                        onFinished: () {
                          setState(() {
                            isP2Finished = true;
                            if (!isUpdateDialogOpen) {
                              Future.delayed(
                                  const Duration(milliseconds: 3000),
                                  () => !isUpdateDialogOpen
                                      ? replaceSplashPage(const HomePage())
                                      : null);
                            }
                          });
                        },
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onBackground,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          ' : ${Strs.appName.split(':').last}  ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontSize: 40,
                                color: Theme.of(context).colorScheme.background,
                              ),
                        ),
                      ),
              )
          ],
        ),
      ),
    );
  }
}
