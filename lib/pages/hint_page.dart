import 'package:flutter/material.dart';

import '../app_options.dart';
import '../controller/level_controller.dart';
import '../utils/utils.dart';
import '../strs.dart';
import '../widgets/close_button.dart';
import '../widgets/hint_widget.dart';

class HintPage extends StatelessWidget {
  HintPage({super.key})
      : hints = ValueNotifier(
            LevelController().currentLevelObjController?.hint ?? -1),
        changeData = ValueNotifier(false);

  final ValueNotifier<int> hints;
  final ValueNotifier<bool> changeData;

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
                const CloseBtn(),
                Expanded(
                  child: Row(
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
                              HintWidget(counter: 1),
                              Icon(Icons.drag_handle_rounded),
                              Icon(Icons.movie_creation_rounded),
                            ],
                          )),
                    ],
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: changeData,
                  builder: (context, value, child) => HintWidget(
                    counter: AppOptions().hintCounter,
                    size: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ValueListenableBuilder(
              valueListenable: hints,
              builder: (context, value, child) {
                return buildTipBlock(
                    context,
                    Strs.smallTip,
                    5,
                    value ==
                            LevelController()
                                .currentLevelObjController
                                ?.hints
                                .length
                        ? null
                        : () {
                            LevelController()
                                .currentLevelObjController
                                ?.incHintNum = 1;
                            hints.value = LevelController()
                                    .currentLevelObjController
                                    ?.hint ??
                                -1;
                          });
              },
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: hints,
              builder: (context, value, child) {
                return buildTipBlock(
                    context,
                    Strs.bigTip,
                    15,
                    LevelController()
                                .currentLevelObjController
                                ?.hints
                                .isEmpty ??
                            false
                        ? null
                        : () {
                            hints.value = -1;
                          });
              },
            ),
            const SizedBox(height: 10),
            buildTipBlock(context, Strs.skipLevel, 20, () {
              LevelController().currentLevelObjController?.passedLevel();
            }),
            const SizedBox(height: 30),
            ValueListenableBuilder(
              valueListenable: hints,
              builder: (context, value, child) {
                if (value == 0) {
                  return const SizedBox.shrink();
                }
                if (value == -1) {
                  return buildTipItem(
                    context,
                    LevelController().currentLevelObjController?.hints.last ??
                        '',
                  );
                }
                return Column(
                  children: List.generate(
                    value,
                    (i) => buildTipItem(
                      context,
                      LevelController().currentLevelObjController?.hints[i] ??
                          '',
                      number: i,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTipBlock(BuildContext context, String title, int cost,
      void Function()? onPressed) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.zero,
        animationDuration: Duration.zero,
      ).copyWith(
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        side: MaterialStateProperty.resolveWith<BorderSide?>(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return const BorderSide(color: Colors.teal, width: 2);
            }
            if (states.contains(MaterialState.disabled)) {
              return const BorderSide(width: 2, color: Colors.transparent);
            }
            return const BorderSide(width: 2);
          },
        ),
      ),
      onPressed: onPressed == null
          ? null
          : () {
              if (AppOptions().hintCounter < cost) return;
              AppOptions().hintCounter -= cost;
              changeData.value = !changeData.value;
              onPressed();
            },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            HintWidget(counter: cost),
          ],
        ),
      ),
    );
  }

  Widget buildTipItem(BuildContext context, String tip, {int? number}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  number == null
                      ? '# ${Strs.bigTip}'
                      : '# ${Strs.tip} ${number + 1}'.toPersianNum(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    tip,
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
