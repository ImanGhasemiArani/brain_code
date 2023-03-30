// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../app_options.dart';
import '../controller/ad_controller.dart';
import '../utils/utils.dart';
import '../routeing.dart';
import '../strs.dart';
import '../widgets/animated_text.dart';
import '../widgets/hint_widget.dart';
import '../widgets/reward_ad_button.dart';
import 'home_page.dart';
import '../controller/level_controller.dart';

class ShutterPage extends StatefulWidget {
  const ShutterPage(this.levelNum, {super.key});

  final int levelNum;

  @override
  State<ShutterPage> createState() => _ShutterPageState();
}

class _ShutterPageState extends State<ShutterPage> {
  String? _bannerAdResId;

  @override
  void initState() {
    AdController().getBannerAd().then((resId) {
      _bannerAdResId = resId;
      _bannerAdResId != null
          ? AdController().showBannerAd(_bannerAdResId!)
          : null;
    });
    super.initState();
  }

  @override
  void dispose() {
    _bannerAdResId != null
        ? AdController().destroyBannerAd(_bannerAdResId!)
        : null;
    _bannerAdResId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.levelNum >= AppOptions().level - 1) {
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
                  child: AnimatedTextFixed(
                    Text(
                      '${Strs.level} ${widget.levelNum} ${Strs.completed}'
                          .toPersianNum(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                ),
              ),
              if (widget.levelNum >= AppOptions().level - 1)
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HintWidget(
                        counter: 1,
                        size: 50,
                      ),
                      SizedBox(height: 30),
                      RewardAdButton(
                        reward: 3,
                        size: 50,
                        infinityUse: false,
                        onRewarded: () {
                          if (widget.levelNum >= AppOptions().level - 1) {
                            AppOptions().hintCounter += 3 - 1;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 5)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return widget.levelNum != levelCounter
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
