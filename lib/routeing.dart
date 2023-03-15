import 'package:flutter/material.dart';

TextEditingController? paletteController;

void openPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    PageRouteBuilder(
      reverseTransitionDuration: const Duration(milliseconds: 500),
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: CurvedAnimation(
          parent: anim1,
          curve: Curves.decelerate,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: anim1,
              curve: Curves.decelerate,
            ),
          ),
          child: child,
        ),
      ),
      pageBuilder: (context, anim1, anim2) => page,
    ),
  );
}

void replacePage(BuildContext context, Widget page) {
  Navigator.of(context).pushReplacement(
    PageRouteBuilder(
      reverseTransitionDuration: const Duration(milliseconds: 1000),
      transitionDuration: const Duration(milliseconds: 1000),
      transitionsBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: CurvedAnimation(
          parent: anim1,
          curve: Curves.decelerate,
        ),
        child: child,
      ),
      pageBuilder: (context, anim1, anim2) => page,
    ),
  );
}
