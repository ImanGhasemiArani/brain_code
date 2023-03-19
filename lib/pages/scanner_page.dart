import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'levels/level_controller.dart';
import 'levels/level_widget.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isEmpty) return;
              LevelController().currentLevelObjController?.scanResult =
                  barcodes.first.rawValue;
              LevelController()
                  .currentLevelObjController
                  ?.checkLevelStatus();
              LevelController().currentLevelObjController?.levelViewEnum.value =
                  LevelViewEnum.none;
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: IconButton(
                style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () => LevelController()
                    .currentLevelObjController
                    ?.levelViewEnum
                    .value = LevelViewEnum.none,
                icon: const Icon(
                  Icons.close_rounded,
                  size: 35,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
