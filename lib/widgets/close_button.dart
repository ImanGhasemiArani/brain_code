import 'package:flutter/material.dart';

class CloseBtn extends StatelessWidget {
  const CloseBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(
        Icons.close_rounded,
        size: 35,
      ),
    );
  }
}
