// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensor;

import '../../routeing.dart';
import '../../strs.dart';
import '../../widgets/hint_widget.dart';
import 'level_obj_controller.dart';

class L9ObjController extends LevelObjController {
  @override
  final Map<String, ValueNotifier<ObjState>> objects = {
    '': ValueNotifier(ObjState('')),
  };

  L9ObjController() {
    currentObj = objects['']!;
  }

  final ValueNotifier<bool> isVertically = ValueNotifier(false);
  final ValueNotifier<bool> isLockOnFace = ValueNotifier(false);
  final ValueNotifier<bool> isRightEyeClosed = ValueNotifier(false);
  final ValueNotifier<bool> isSmiling = ValueNotifier(false);
  final ValueNotifier<bool> isRunningTime = ValueNotifier(false);
  StreamSubscription<sensor.AccelerometerEvent>? sub;
  bool isPassed = false;

  void checkConditions() {
    if (isVertically.value &&
        isLockOnFace.value &&
        isRightEyeClosed.value &&
        isSmiling.value) {
      isRunningTime.value = true;
    } else {
      isRunningTime.value = false;
    }
  }

  void listenAccelerometer(bool isListen) {
    if (isListen) {
      sub = sensor.accelerometerEvents.listen(_accelerometerListener);
    } else {
      sub?.cancel();
      sub = null;
    }
  }

  void _accelerometerListener(sensor.AccelerometerEvent event) {
    if (sub == null) return;

    // print("${event.x}" ' ' "${event.y}" ' ' '${event.z}');
    if (event.y >= 9 && event.y < 10) {
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
  bool isLevelPassed() {
    return isPassed;
  }
}

class L9 extends StatefulWidget {
  const L9(this.controller, {super.key});

  final L9ObjController controller;

  @override
  State<L9> createState() => _L9State();
}

class _L9State extends State<L9> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        replacePage(_L9(controller: widget.controller));
      },
    );
    return const SizedBox.shrink();
  }
}

class _L9 extends StatefulWidget {
  const _L9({required this.controller});

  final L9ObjController controller;

  @override
  State<_L9> createState() => _L9State2();
}

class _L9State2 extends State<_L9> {
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
                // widget.controller.isLockOnFace.value =
                //     '${face.headEulerAngleX}\n${face.headEulerAngleY}\n${face.headEulerAngleZ}\n${face.rightEyeOpenProbability}\n${face.leftEyeOpenProbability}\n${face.smilingProbability}';
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
          Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 120, right: 20, left: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                      height: 50,
                      child: ValueListenableBuilder(
                        valueListenable: widget.controller.isRunningTime,
                        builder: (context, value2, child) {
                          const totalD = Duration(minutes: 2);
                          const t = 0.001;
                          final partD = totalD * t;
                          double value = 0.0;
                          return StatefulBuilder(
                            builder: (context, setState) {
                              if (value2) {
                                Future.delayed(
                                  partD,
                                  () {
                                    if (value < 1) {
                                      setState(() {
                                        value += t;
                                      });
                                    } else {
                                      widget.controller.isPassed = true;
                                      widget.controller.checkLevelStatus();
                                    }
                                  },
                                );
                              }
                              return LiquidLinearProgressIndicator(
                                value: value,
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
                  const SizedBox(height: 30),
                  ValueListenableBuilder(
                    valueListenable: widget.controller.isVertically,
                    builder: (context, value, child) {
                      return Text(
                        Strs.l9S1,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: value
                                  ? Colors.tealAccent.shade700
                                  : Colors.red.shade700,
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  ValueListenableBuilder(
                    valueListenable: widget.controller.isLockOnFace,
                    builder: (context, value, child) {
                      return Text(
                        Strs.l9S2,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: value
                                  ? Colors.tealAccent.shade700
                                  : Colors.red.shade700,
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  ValueListenableBuilder(
                    valueListenable: widget.controller.isRightEyeClosed,
                    builder: (context, value, child) {
                      return Text(
                        Strs.l9S3,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: value
                                  ? Colors.tealAccent.shade700
                                  : Colors.red.shade700,
                            ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  ValueListenableBuilder(
                    valueListenable: widget.controller.isSmiling,
                    builder: (context, value, child) {
                      return Text(
                        Strs.l9S4,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: value
                                  ? Colors.tealAccent.shade700
                                  : Colors.red.shade700,
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: HintButton(),
            ),
          ),
        ],
      ),
    );
  }
}

typedef OnFaceDetect = void Function(List<Face> faces);

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({super.key, this.onFaceDetect});

  final OnFaceDetect? onFaceDetect;

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  final options = FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
    enableLandmarks: true,
  );
  late final faceDetector = FaceDetector(options: options);

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraAwesomeBuilder.custom(
        saveConfig: SaveConfig.photo(
          pathBuilder: () => Future(() => ''),
        ),
        previewFit: CameraPreviewFit.cover,
        aspectRatio: CameraAspectRatios.ratio_16_9,
        enableAudio: false,
        sensor: Sensors.front,
        onImageForAnalysis: (img) => _analyzeImage(img),
        imageAnalysisConfig: AnalysisConfig(
          outputFormat: InputAnalysisImageFormat.nv21,
          width: 250,
          maxFramesPerSecond: 12,
        ),
        builder: (state, previewSize, previewRect) {
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future _analyzeImage(AnalysisImage img) async {
    final InputImageRotation imageRotation =
        InputImageRotation.values.byName(img.rotation.name);

    final planeData = img.planes.map(
      (ImagePlane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final InputImage inputImage;
    inputImage = InputImage.fromBytes(
      bytes: img.nv21Image!,
      inputImageData: InputImageData(
        imageRotation: imageRotation,
        inputImageFormat: InputImageFormat.nv21,
        planeData: planeData,
        size: Size(img.width.toDouble(), img.height.toDouble()),
      ),
    );

    try {
      final faces = await faceDetector.processImage(inputImage);
      widget.onFaceDetect?.call(faces);
    } catch (error) {
      debugPrint("...sending image resulted error $error");
    }
  }

  InputImageFormat inputImageFormat(InputAnalysisImageFormat format) {
    switch (format) {
      case InputAnalysisImageFormat.bgra8888:
        return InputImageFormat.bgra8888;
      case InputAnalysisImageFormat.nv21:
        return InputImageFormat.nv21;
      default:
        return InputImageFormat.yuv420;
    }
  }
}
