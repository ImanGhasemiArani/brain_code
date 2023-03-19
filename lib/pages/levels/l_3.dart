// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../../strs.dart';
import 'level_controller.dart';
import 'level_obj_controller.dart';

class L3ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L3ObjController() {
    currentObj = objects['']!;
  }

  bool isComplete = false;

  @override
  void runCommandAnim(BuildContext context, String str) {
    final arg = str.split(':').last == 'start' ? true : false;
    currentObj.value.edit(nia: arg);

    currentObj.notifyListeners();

    // super.runCommandAnim(context, str);
  }

  @override
  bool isLevelPassed() {
    return isComplete;
  }
}

class L3 extends StatefulWidget {
  const L3(this.controller, {super.key});

  final L3ObjController controller;

  @override
  State<L3> createState() => _L3State();
}

class _L3State extends State<L3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.ltr,
              children: [
                Text(
                  Strs.l3S1,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(width: 10),
                _L3Anim(
                  const [Strs.l3S2, Strs.l3S3],
                  widget.controller.getObj(''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _L3Anim extends StatefulWidget {
  const _L3Anim(this.texts, this.state);

  final List<String> texts;
  final Duration duration = const Duration(milliseconds: 750);
  final ValueNotifier<ObjState> state;

  @override
  State<_L3Anim> createState() => _L3AnimState();
}

class _L3AnimState extends State<_L3Anim> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _index = 0;
    widget.state.addListener(_listener);
    _switchText();
  }

  void _listener() {
    final isAnim = widget.state.value.isAnim ?? true;
    if (!isAnim) {
      _controller.stop();
      Future.delayed(widget.duration, () {
        if (widget.texts[_index] == Strs.l3S2) {
          try {
            (LevelController().currentLevelObjController as L3ObjController)
                .isComplete = true;
            LevelController()
                .currentLevelObjController
                ?.checkLevelStatus();
          } catch (e) {}
        }
      });
    } else {
      _switchText();
    }
  }

  @override
  void dispose() {
    widget.state.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  void _switchText() {
    setState(() {
      _index = (_index + 1) % widget.texts.length;
    });
    _controller.reset();
    _controller.forward().then((value) {
      _switchText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: AnimatedSwitcher(
        duration: widget.duration,
        child: Text(
          widget.texts[_index],
          key: ValueKey(widget.texts[_index]),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        transitionBuilder: (child, animation) {
          late final Tween<Offset> position;
          if (widget.texts.indexOf((child as Text).data!) % 2 == 0) {
            position = Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            );
          } else {
            position = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            );
          }
          return SlideTransition(
            position: position.animate(animation),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
