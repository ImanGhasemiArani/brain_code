import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../routeing.dart';
import '../utils/utils.dart';
import '../strs.dart';

class HintWidget extends StatelessWidget {
  const HintWidget({
    super.key,
    this.counter = -1,
    this.size = 24,
  });

  final int counter;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      Strs.urlHintIcon,
      height: size,
      width: size,
    );

    if (counter == -1) {
      return icon;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$counter ×'.toPersianNum(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        icon,
      ],
    );
  }
}

class HintButton extends StatelessWidget {
  const HintButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        openHintPage();
      },
      icon: const HintWidget(
        size: 35,
      ),
    );
  }
}
