import 'package:flutter/material.dart';

import '../strs.dart';

class InDevPage extends StatelessWidget {
  const InDevPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.close_rounded,
            size: 35,
          ),
        ),
      ),
      body: Center(
        child: Text(
          Strs.inDev,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
