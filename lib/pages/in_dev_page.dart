import 'package:flutter/material.dart';

import '../strs.dart';
import '../widgets/close_button.dart';

class InDevPage extends StatelessWidget {
  const InDevPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CloseBtn(),
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
