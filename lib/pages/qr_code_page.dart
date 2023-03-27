import 'package:flutter/material.dart';

import '../widgets/qr_code_widget.dart';
import '../controller/level_controller.dart';
import 'levels/level_widget.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({
    super.key,
    this.data,
    this.bColor,
    this.fColor,
  });

  final String? data;
  final Color? bColor;
  final Color? fColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: QRCodeView(
              data: data,
              bColor: bColor,
              fColor: fColor,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: IconButton(
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
