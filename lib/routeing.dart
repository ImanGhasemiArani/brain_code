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

void replaceSplashPage(
  BuildContext context,
  Widget page,
) {
  Navigator.of(context).pushReplacement(
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

void replacePage(BuildContext context, Widget page,
    {Offset b = const Offset(0, 1), Offset e = Offset.zero}) {
  Navigator.of(context).pushReplacement(
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
