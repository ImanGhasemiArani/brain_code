// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../strs.dart';
import 'level_obj_controller.dart';

class L4ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    'all': ValueNotifier(ObjState('all')),
    'c1': ValueNotifier(ObjState('c1')),
    'c2': ValueNotifier(ObjState('c2')),
  };

  L4ObjController() {
    currentObj = objects['all']!;
  }

  double degreeC1 = -500;
  double degreeC2 = -500;

  @override
  void runCommandAnim(BuildContext context, String str) {
    final arg = str.split(':').last == 'start' ? true : false;
    currentObj.value.edit(nia: arg);

    currentObj.notifyListeners();

    // super.runCommandAnim(context, str);
  }

  @override
  bool isLevelPassed() {
    return 67.5 <= degreeC1 &&
        degreeC1 <= 112.5 &&
        22.5 <= degreeC2 &&
        degreeC2 <= 67.5;
  }
}

class L4 extends StatefulWidget {
  const L4(this.controller, {super.key});

  final L4ObjController controller;

  @override
  State<L4> createState() => _L4State();
}

class _L4State extends State<L4> {
  @override
  Widget build(BuildContext context) {
    const r = 100.0;
    return Scaffold(
      body: Stack(
        children: [
          AlignPositioned(
            alignment: Alignment.centerLeft,
            dx: -r,
            child: _CirclePart(
              r,
              const ['6', '10', '5', '2', '15', '0', '-6', '-7'],
              widget.controller.getObj('c1'),
              widget.controller,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: _MidWidget(MediaQuery.of(context).size.width - 2 * r),
          ),
          AlignPositioned(
            alignment: Alignment.centerRight,
            dx: r,
            child: _CirclePart(
              r,
              const ['1', '2', '3', '5', '7', '9', '-12', '15'],
              widget.controller.getObj('c2'),
              widget.controller,
            ),
          ),
        ],
      ),
    );
  }
}

class _MidWidget extends StatelessWidget {
  const _MidWidget(this.width);

  final double width;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium;

    return SizedBox(
      width: width,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            Strs.l4S1.split(' ').length,
            (index) => Text(
              Strs.l4S1.split(' ')[index].toPersianNum(),
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}

class _CirclePart extends StatefulWidget {
  const _CirclePart(
    this.r,
    this.texts,
    this.state,
    this.controller,
  );

  final double r;
  final List<String> texts;
  final ValueNotifier<ObjState> state;
  final L4ObjController controller;

  final Duration duration = const Duration(milliseconds: 6000);

  static final List<Alignment> alignments = [
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerRight,
    Alignment.bottomRight,
    Alignment.bottomCenter,
    Alignment.bottomLeft,
    Alignment.centerLeft,
    Alignment.topLeft,
  ];
//   ]..shuffle();

  static const List<Alignment> alignmentsR = [
    Alignment.topCenter,
    Alignment.centerRight,
    Alignment.bottomCenter,
    Alignment.centerLeft,
  ];

  @override
  State<_CirclePart> createState() => _CirclePartState();
}

class _CirclePartState extends State<_CirclePart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    widget.state.addListener(_startAnim);
  }

  @override
  void dispose() {
    widget.state.removeListener(_startAnim);
    _controller.dispose();
    super.dispose();
  }

  void _startAnim() {
    final isStart = widget.state.value.isAnim ?? true;
    if (isStart) {
      _controller.repeat();
    } else {
      _controller.stop();
      if (widget.state.value.objLabel == 'c1') {
        widget.controller.degreeC1 = _controller.value * 360;
      } else {
        widget.controller.degreeC2 = _controller.value * 360;
      }

      widget.controller.isLevelPassed()
          ? widget.controller.passedLevel(context)
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Container(
        height: widget.r * 2,
        width: widget.r * 2,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.tertiary),
          shape: BoxShape.circle,
        ),
        child: _CirclePartContent(texts: widget.texts),
      ),
    );
  }
}

class _CirclePartContent extends StatelessWidget {
  const _CirclePartContent({
    required this.texts,
  });

  final List<String> texts;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
          texts.length,
          (index) => Align(
                alignment: _CirclePart.alignments[index],
                child: Padding(
                  padding: EdgeInsets.all(_CirclePart.alignmentsR
                          .contains(_CirclePart.alignments[index])
                      ? 20
                      : 40),
                  child: Text(
                    texts[index].toPersianNum(),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              )),
    );
  }
}
