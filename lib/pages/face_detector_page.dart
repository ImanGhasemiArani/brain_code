import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';

typedef OnFaceDetect = void Function(List<Face> faces);
typedef OverLayBuilder = Widget Function(CameraState state);

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({
    super.key,
    this.onFaceDetect,
    this.overlayBuilder = defaultOverlay,
    this.aspectRatio = CameraAspectRatios.ratio_16_9,
    required this.level,
  });

  static Widget defaultOverlay(CameraState s) => const SizedBox.shrink();

  final CameraAspectRatios aspectRatio;
  final OnFaceDetect? onFaceDetect;
  final OverLayBuilder overlayBuilder;
  final int level;

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
          pathBuilder: () async {
            final path = '${(await getApplicationSupportDirectory()).path}/'
                'imgL${widget.level}/'
                '${DateTime.now().millisecondsSinceEpoch}'
                '.jpg';
            return path;
          },
        ),
        previewFit: CameraPreviewFit.cover,
        aspectRatio: widget.aspectRatio,
        enableAudio: false,
        sensor: Sensors.front,
        onImageForAnalysis: (img) => _analyzeImage(img),
        imageAnalysisConfig: AnalysisConfig(
          outputFormat: InputAnalysisImageFormat.nv21,
          width: 250,
          maxFramesPerSecond: 12,
        ),
        builder: (state, previewSize, previewRect) =>
            widget.overlayBuilder(state),
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
