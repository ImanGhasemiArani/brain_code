import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';

import '../pages/levels/obj_state.dart';


class MovableObject extends StatefulWidget {
  const MovableObject({
    super.key,
    required this.state,
    this.child,
    required this.alignment,
    required this.initPosition,
    this.textStyle,
  });

  final Widget? child;
  final ValueNotifier<ObjState> state;
  final Alignment alignment;
  final Offset initPosition;
  final TextStyle? textStyle;

  @override
  State<MovableObject> createState() => _MovableObjectState();
}

class _MovableObjectState extends State<MovableObject> {
  final ObjState currentState = ObjState('');
  bool scaleAnim = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: widget.state,
          child: widget.child,
          builder: (context, value, child) {
            currentState.edit(
              np: value.position + currentState.position,
              nr: value.rotation + currentState.rotation,
              nia: value.isAnim,
              nt: value.text,
            );
            scaleAnim = value.isAnim ? !scaleAnim : scaleAnim;

            return AnimatedAlignPositioned(
              duration: const Duration(milliseconds: 300),
              alignment: widget.alignment,
              dx: widget.initPosition.dx + currentState.position.dx,
              dy: widget.initPosition.dy + currentState.position.dy,
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 300),
                turns: currentState.rotation / 360,
                child: StatefulBuilder(
                  builder: (context, setState2) {
                    return AnimatedScale(
                      scale: scaleAnim ? 1.5 : 1,
                      onEnd: currentState.isAnim
                          ? () => setState2(() => scaleAnim = !scaleAnim)
                          : null,
                      duration: const Duration(milliseconds: 400),
                      child: widget.textStyle != null
                          ? Text(
                              currentState.text ?? '',
                              style: widget.textStyle,
                            )
                          : child,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
