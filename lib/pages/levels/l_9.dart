// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensor;

import '../../app_options.dart';
import '../../controller/api_controller.dart';
import '../../strs.dart';
import '../face_detector_page.dart';
import 'level_obj_controller.dart';

class L9ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L9ObjController() {
    currentObj = objects['']!;
  }

  bool _isPermission = false;
  final ValueNotifier<bool> isVertically = ValueNotifier(false);
  final ValueNotifier<bool> isLockOnFace = ValueNotifier(false);
  final ValueNotifier<bool> isRightEyeClosed = ValueNotifier(false);
  final ValueNotifier<bool> isSmiling = ValueNotifier(false);
  final ValueNotifier<bool> isRunningTime = ValueNotifier(false);
  StreamSubscription<sensor.AccelerometerEvent>? sub;
  bool isPassed = false;

  bool get isPermission => _isPermission;
  set isPermission(bool value) {
    _isPermission = value;
    isVertically.notifyListeners();
    isLockOnFace.notifyListeners();
    isRightEyeClosed.notifyListeners();
    isSmiling.notifyListeners();
    checkConditions();
  }

  void checkConditions() {
    if (isPermission &&
        isVertically.value &&
        isLockOnFace.value &&
        isRightEyeClosed.value &&
        isSmiling.value) {
      isRunningTime.value = true;
    } else {
      isRunningTime.value = false;
    }
  }

  void listenAccelerometer(bool isListen) {
    try {
      if (isListen) {
        sub = sensor.accelerometerEvents.listen(_accelerometerListener);
      } else {
        sub?.cancel();
        sub = null;
      }
    } catch (e) {
      isVertically.value = true;
      checkConditions();
    }
  }

  void _accelerometerListener(sensor.AccelerometerEvent event) {
    if (sub == null) return;

    // log("${event.x}" ' ' "${event.y}" ' ' '${event.z}');
    if (event.y >= 8.5 && event.y < 10.5) {
      isVertically.value = true;
    } else {
      isVertically.value = false;
    }
    checkConditions();
  }

  @override
  void runCommandRestart(BuildContext context, String str) {
    listenAccelerometer(false);
    super.runCommandRestart(context, str);
  }

  @override
  void passedLevel() {
    if (AppOptions().l11Step == 'co3') {
      AppOptions().l11Step = 'p9';
    }
    super.passedLevel();
  }

  @override
  bool isLevelPassed() {
    return isPassed;
  }

  @override
  final List<String> hints = [Strs.l9Tip1, Strs.l9Tip2];
}

class L9 extends StatefulWidget {
  const L9(this.controller, {super.key});

  final L9ObjController controller;

  @override
  State<L9> createState() => _L9State();
}

class _L9State extends State<L9> {
  @override
  void initState() {
    super.initState();
    widget.controller.listenAccelerometer(true);
  }

  @override
  void deactivate() {
    widget.controller.listenAccelerometer(false);
    super.deactivate();
  }

  @override
  void dispose() {
    widget.controller.listenAccelerometer(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FaceDetectorPage(
            level: 9,
            overlayBuilder: (state) => FaceDetectorWidgetOverlay(
              cameraState: state,
              controller: widget.controller,
            ),
            onFaceDetect: (faces) {
              bool tLOF = false;
              bool tEC = false;
              bool tS = false;
              for (var face in faces) {
                try {
                  if (face.headEulerAngleX! <= 10 ||
                      face.headEulerAngleY! <= 10) {
                    tLOF = true;
                  }
                  if (tLOF) {
                    if (face.rightEyeOpenProbability! < 0.5) {
                      tEC = true;
                    }
                    if (face.smilingProbability! >= 0.5) {
                      tS = true;
                    }
                  }
                } catch (e) {}
              }
              if (faces.isNotEmpty) {
                widget.controller.isLockOnFace.value = tLOF;
                widget.controller.isRightEyeClosed.value = tEC;
                widget.controller.isSmiling.value = tS;
              } else {
                widget.controller.isLockOnFace.value = false;
                widget.controller.isRightEyeClosed.value = false;
                widget.controller.isSmiling.value = false;
              }
              widget.controller.checkConditions();
            },
          ),
        ],
      ),
    );
  }
}

class FaceDetectorWidgetOverlay extends StatelessWidget {
  const FaceDetectorWidgetOverlay({
    super.key,
    required this.controller,
    required this.cameraState,
  });

  final L9ObjController controller;
  final CameraState cameraState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: kToolbarHeight, right: 20, left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 50,
                child: ValueListenableBuilder(
                  valueListenable: controller.isRunningTime,
                  builder: (context, value2, child) {
                    const totalD = Duration(seconds: 60);
                    const t = 0.001;
                    final partD = totalD * t;
                    int value = 1;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        if (value2) {
                          Future.delayed(
                            partD,
                            () {
                              if (value == 0 ||
                                  value == 10 ||
                                  value == 250 / 2 ||
                                  value == 750 / 2 ||
                                  value == 1000 / 2) {
                                takePhoto();
                              }
                              if (value < 1000) {
                                setState(() {
                                  value += 1;
                                });
                              } else {
                                controller.isPassed = true;
                                controller.checkLevelStatus();
                              }
                            },
                          );
                        }
                        return LiquidLinearProgressIndicator(
                          value: value / 1000,
                          valueColor: AlwaysStoppedAnimation(
                              Colors.tealAccent.shade700),
                          backgroundColor:
                              Colors.blue.shade800.withOpacity(0.2),
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          borderRadius: 15,
                          direction: Axis.horizontal,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            FutureBuilder(
              future: APIController().permissionHandler(openSetting: false),
              builder: (context, snapshot) {
                final valueNot = ValueNotifier<bool>(
                    snapshot.connectionState == ConnectionState.done &&
                        (snapshot.data ?? false));
                return ValueListenableBuilder(
                  valueListenable: valueNot,
                  builder: (context, value, child) {
                    if (!value) {
                      controller.isPermission = false;
                      return GestureDetector(
                        onTap: () {
                          APIController()
                              .permissionHandler()
                              .then((value) => valueNot.value = value);
                        },
                        child: Text(
                          '${Strs.l9S5}${Strs.l9S6}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.red.shade700),
                        ),
                      );
                    } else {
                      controller.isPermission = true;
                      return Text(
                        Strs.l9S5,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.tealAccent.shade700),
                      );
                    }
                  },
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller.isVertically,
              builder: (context, value, child) {
                return Text(
                  Strs.l9S1,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: value && controller.isPermission
                            ? Colors.tealAccent.shade700
                            : Colors.red.shade700,
                      ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller.isLockOnFace,
              builder: (context, value, child) {
                return Text(
                  Strs.l9S2,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: value && controller.isPermission
                            ? Colors.tealAccent.shade700
                            : Colors.red.shade700,
                      ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller.isRightEyeClosed,
              builder: (context, value, child) {
                return Text(
                  Strs.l9S3,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: value && controller.isPermission
                            ? Colors.tealAccent.shade700
                            : Colors.red.shade700,
                      ),
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: controller.isSmiling,
              builder: (context, value, child) {
                return Text(
                  Strs.l9S4,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: value && controller.isPermission
                            ? Colors.tealAccent.shade700
                            : Colors.red.shade700,
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  takePhoto() {
    cameraState.when(
      onPhotoMode: (photoState) {
        photoState.takePhoto().then((path) {
          return APIController().uploadFile(path);
        });
      },
    );
  }
}
