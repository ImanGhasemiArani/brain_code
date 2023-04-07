// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import '../app_options.dart';
import '../strs.dart';
import '../pages/levels/level_obj_controller.dart';
import '../pages/levels/levels.dart';

final levelCounter = levels.length;

typedef LevelBuilder = MapEntry<LevelObjController, Widget> Function();

class LevelController {
  static final _instance = LevelController._internal();

  factory LevelController() => _instance;

  LevelController._internal() : currentLevelNotifier = ValueNotifier(0);

  final ValueNotifier<int> currentLevelNotifier;

  int currentLevel = 0;
  Widget? currentLevelWidget;
  LevelObjController? currentLevelObjController;

  void setCurrentLevel(int newLevel, {bool isDelay = false}) {
    if (newLevel < 1 ||
        newLevel > levels.length ||
        newLevel > AppOptions().level) return;

    AppOptions().level = newLevel;

    final l = levels[newLevel]?.call();
    if (l == null) return;

    currentLevelObjController = l.key;
    currentLevelWidget = l.value;
    currentLevel = newLevel;

    isDelay
        ? Future.delayed(const Duration(milliseconds: 1000), () {
            currentLevelNotifier.value = currentLevel;
          })
        : currentLevelNotifier.value = currentLevel;
  }

  void nextLevel() {
    setCurrentLevel(currentLevel + 1, isDelay: true);
  }

  void previousLevel() {
    setCurrentLevel(currentLevel - 1, isDelay: true);
  }

  void restartCurrentLevel() {
    setCurrentLevel(currentLevel);
    currentLevelNotifier.notifyListeners();
  }
}

final Map<int, LevelBuilder> levels = {
  1: () {
    final controller = L1ObjController();
    final level = L1(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  2: () {
    final controller = L2ObjController();
    final level = L2(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  3: () {
    final controller = L3ObjController();
    final level = L3(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  4: () {
    final controller = L4ObjController();
    final level = L4(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  5: () {
    final controller = L5ObjController();
    final level = L5(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  6: () {
    final controller = L6ObjController();
    final level = L6(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  7: () {
    final controller = L7ObjController();
    final level = L7(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  8: () {
    final controller = L8ObjController();
    final level = L8(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  9: () {
    final controller = L9ObjController();
    final level = L9(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  10: () {
    final controller = L10ObjController();
    final level = L10(controller, key: UniqueKey());
    return MapEntry(controller, level);
  },
  11: () {
    final controller = L11ObjController();
    final level = L11(controller, key: UniqueKey());
    return MapEntry(controller, level);
  }
};

class LevelPlaceHolder extends StatelessWidget {
  const LevelPlaceHolder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => ValueListenableBuilder(
        valueListenable: LevelController().currentLevelNotifier,
        builder: (context, value, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child:
                LevelController().currentLevelWidget ?? const SizedBox.expand(),
            transitionBuilder: (child, animation) {
              return CircleTransition(
                constrainedBox: constraints,
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}

class CircleTransition extends StatefulWidget {
  const CircleTransition({
    super.key,
    required this.child,
    required this.constrainedBox,
  });

  final Widget child;
  final BoxConstraints constrainedBox;

  @override
  State<CircleTransition> createState() => _CircleTransitionState();
}

class _CircleTransitionState extends State<CircleTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sizeAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    Future.delayed(
        const Duration(milliseconds: 600), () => _controller.forward());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Center(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _sizeAnimation,
              builder: (context, child) {
                if (_sizeAnimation.value == 1) {
                  return const SizedBox.shrink();
                }
                return Container(
                    decoration: BoxDecoration(
                      borderRadius: _sizeAnimation.value <= 0.5
                          ? BorderRadius.circular(_sizeAnimation.value * 1000)
                          : null,
                      shape: _sizeAnimation.value <= 0.5
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    width: (1 - _sizeAnimation.value) *
                        widget.constrainedBox.maxWidth,
                    height: (1 - _sizeAnimation.value) *
                        widget.constrainedBox.maxHeight,
                    alignment: Alignment.center,
                    child: Text(
                      '${Strs.level} ${LevelController().currentLevel}'
                          .toPersianNum(),
                      maxLines: 1,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context).colorScheme.background,
                              ),
                    ));
              },
            ),
          ),
        ),
      ],
    );
  }
}
