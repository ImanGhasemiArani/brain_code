import 'package:flutter/material.dart';

import 'main.dart';

TextEditingController? paletteController;

void openPage(Widget page) {
  navKey.currentState?.push(
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

void replaceSplashPage(
  Widget page,
) {
  navKey.currentState?.pushReplacement(
    PageRouteBuilder(
      reverseTransitionDuration: const Duration(milliseconds: 800),
      transitionDuration: const Duration(milliseconds: 800),
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

void replacePage(Widget page,
    {Offset b = const Offset(0, 1), Offset e = Offset.zero}) {
  navKey.currentState?.pushReplacement(
    PageRouteBuilder(
      reverseTransitionDuration: const Duration(milliseconds: 800),
      transitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: CurvedAnimation(
          parent: anim1,
          curve: Curves.decelerate,
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: b,
            end: e,
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
