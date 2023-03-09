import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedTextFixed extends StatefulWidget {
  const AnimatedTextFixed(this.text, {super.key});

  final Text text;

  @override
  State<AnimatedTextFixed> createState() => _AnimatedTextFixedState();
}

class _AnimatedTextFixedState extends State<AnimatedTextFixed> {
  bool isAnimated = true;
  @override
  Widget build(BuildContext context) {
    return isAnimated
        ? AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                widget.text.data ?? '',
                textStyle: widget.text.style,
                cursor: '|',
              ),
            ],
            isRepeatingAnimation: false,
            onFinished: () => isAnimated = false,
          )
        : Text(
            '${widget.text.data ?? ''}   ',
            style: widget.text.style,
          );
  }
}
