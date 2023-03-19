import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeView extends StatelessWidget {
  const QRCodeView({
    super.key,
    this.data,
    this.size,
    this.bColor,
    this.fColor,
  });

  final String? data;
  final double? size;
  final Color? bColor;
  final Color? fColor;

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: data ?? 'imanghasemiarani.github.io',
      backgroundColor: bColor ?? Theme.of(context).colorScheme.background,
      foregroundColor: fColor ?? Theme.of(context).colorScheme.onBackground,
      dataModuleStyle: const QrDataModuleStyle(
        color: Colors.black,
        dataModuleShape: QrDataModuleShape.circle,
      ),
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.circle,
        color: Colors.black,
      ),
      gapless: false,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
      padding: EdgeInsets.zero,
      size: size ?? MediaQuery.of(context).size.width * 0.55,
    );
  }
}
