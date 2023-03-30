import 'package:flutter/material.dart';

import '../controller/ad_controller.dart';
import 'hint_widget.dart';

class RewardAdButton extends StatefulWidget {
  const RewardAdButton({
    super.key,
    this.reward = 1,
    this.size = 24,
    this.infinityUse = true,
    this.onRewarded,
  });

  final int reward;
  final double size;
  final bool infinityUse;
  final void Function()? onRewarded;

  @override
  State<RewardAdButton> createState() => _RewardAdButtonState();
}

class _RewardAdButtonState extends State<RewardAdButton> {
  bool isEnable = true;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: isEnable
          ? () async {
              setState(() => isEnable = false);
              final res = await AdController()
                  .showRewardedAd(() => widget.onRewarded?.call());
              if (!res || widget.infinityUse) {
                setState(() => isEnable = true);
              }
            }
          : null,
      child: isEnable
          ? Row(
              children: [
                HintWidget(counter: widget.reward, size: widget.size),
                const Icon(Icons.drag_handle_rounded),
                Icon(Icons.movie_creation_rounded, size: widget.size),
              ],
            )
          : SizedBox.square(
              dimension: widget.size,
              child: const CircularProgressIndicator(),
            ),
    );
  }
}
