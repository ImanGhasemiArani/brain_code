import 'dart:math';

import 'package:flutter/material.dart';

import '../controller/commands_controller.dart';

const _objSize = Size.square(15);
const _h = 100.0;

class ReactiveAnim extends StatelessWidget {
  const ReactiveAnim({super.key, required this.colors});

  final Map<Color, List<int>> colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _h,
      width: double.infinity,
      child: Stack(
          children: List.generate(
        50,
        (index) {
          final t = Random().nextInt(10);
          final color = colors.entries
              .firstWhere((element) => element.value.contains(t))
              .key
              .withOpacity(Random().nextDouble());
          return ReactiveAnimObj(color: color);
        },
      )),
    );
  }
}

class ReactiveAnimObj extends StatefulWidget {
  const ReactiveAnimObj({super.key, required this.color});

  final Color color;

  @override
  State<ReactiveAnimObj> createState() => _ReactiveAnimObjState();
}

class _ReactiveAnimObjState extends State<ReactiveAnimObj> {
  double xp = -100;
  double yp = -_objSize.height;
  Duration duration = Duration(milliseconds: Random().nextInt(251) + 250);

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        yp = Random().nextInt((_h * 0.8 - _objSize.height).toInt()) + _h * 0.2;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    xp == -100
        ? xp = Random()
            .nextInt(
                (MediaQuery.of(context).size.width - _objSize.width).toInt())
            .toDouble()
        : null;
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: duration,
            bottom: yp,
            left: xp,
            child: AnimatedOpacity(
              duration: duration,
              opacity: yp == -_objSize.height ? 1 : 0,
              child: Container(
                height: _objSize.height,
                width: _objSize.width,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReactiveAnimPlaceHolder extends StatelessWidget {
  const ReactiveAnimPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CommandsController().reactiveAnimController,
      builder: (context, value, child) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          CommandsController().reactiveAnimController.value = null;
        });
        return value == null
            ? const SizedBox.shrink()
            : Align(
                alignment: Alignment.bottomCenter,
                child: value
                    ? ReactiveAnim(colors: {
                        Colors.blue.shade800: const [0, 3, 6, 9],
                        Colors.tealAccent.shade700: const [1, 2, 4, 5, 7, 8],
                      })
                    : ReactiveAnim(colors: {
                        Colors.red: const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                      }),
              );
      },
    );
  }
}
