import 'package:flutter/material.dart';

import '../app_options.dart';
import '../utils/utils.dart';
import '../strs.dart';
import '../widgets/close_button.dart';
import '../widgets/hint_widget.dart';

class DailyPrizePage extends StatelessWidget {
  const DailyPrizePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  Strs.dailyPrize,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Spacer(),
                const CloseBtn(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPrize(context, 2, 1),
                _buildPrize(context, 2, 2),
                _buildPrize(context, 2, 3),
                _buildPrize(context, 2, 4),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPrize(context, 3, 5),
                _buildPrize(context, 3, 6),
                _buildPrize(context, 5, 7),
                _buildPrize(context, 5, 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrize(BuildContext context, int prizeNum, int dayNum) {
    final ValueNotifier<bool> changeState = ValueNotifier<bool>(false);
    return ValueListenableBuilder(
        valueListenable: changeState,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: AppOptions().allowedDailyPrize < dayNum ||
                        AppOptions().awardedDailyPrize >= dayNum
                    ? null
                    : () {
                        AppOptions().awardedDailyPrize += 1;
                        AppOptions().hintCounter += prizeNum;
                        changeState.value = !changeState.value;
                      },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: AppOptions().awardedDailyPrize < dayNum
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : Colors.transparent,
                ),
                child: SizedBox.square(
                  dimension: (MediaQuery.of(context).size.width - 40 - 30) / 4,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Stack(
                        children: [
                          Center(
                            child: HintWidget(
                              counter: prizeNum,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: AppOptions().allowedDailyPrize < dayNum
                                ? const Icon(Icons.lock_rounded, size: 20)
                                : AppOptions().awardedDailyPrize < dayNum
                                    ? const SizedBox.shrink()
                                    : const Icon(Icons.check_rounded, size: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                '${Strs.day} $dayNum'.toPersianNum(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          );
        });
  }
}
