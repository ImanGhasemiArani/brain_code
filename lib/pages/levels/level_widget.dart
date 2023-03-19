import 'package:flutter/material.dart';

import '../qr_code_page.dart';
import '../scanner_page.dart';

class LevelView extends StatelessWidget {
  const LevelView({
    super.key,
    required this.child,
    required this.lve,
  });

  final Widget child;
  final ValueNotifier<LevelViewEnum> lve;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ValueListenableBuilder(
            valueListenable: lve,
            builder: (context, value, child) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: () {
                  switch (value) {
                    case LevelViewEnum.qrCode:
                      return const QRCodePage();
                    case LevelViewEnum.scanner:
                      return const ScannerPage();
                    default:
                      return const SizedBox.expand();
                  }
                }())),
      ],
    );
  }
}

enum LevelViewEnum {
  scanner,
  qrCode,
  none,
}
