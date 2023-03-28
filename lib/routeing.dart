import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import 'app_options.dart';
import 'pages/hint_page.dart';
import 'utils/utils.dart';
import 'main.dart';
import 'pages/home_page.dart';
import 'strs.dart';

TextEditingController? paletteController;

bool isUpdateDialogOpen = false;
bool isCloseSplashScreen = false;

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

void showUpdateDialog(Map<String, dynamic> info) {
  isUpdateDialogOpen = true;
  AppOptions().setIsHaveForceUpdate(info['isForcible']);
  showGeneralDialog(
    context: navKey.currentContext!,
    pageBuilder: (context, animation, secondaryAnimation) {
      return AlertDialog(
        scrollable: true,
        insetPadding: const EdgeInsets.symmetric(vertical: 100),
        icon: Icon(
          Icons.update_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        title: Row(
          children: [
            Text(
              Strs.titleUpdateMsg,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${Strs.version} ${info['version']}'.toPersianNum(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (info['isForcible']) const SizedBox(height: 5),
            if (info['isForcible'])
              Text(
                Strs.updateForcible,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red.shade700,
                    ),
              ),
            if (info['description'] != null) const SizedBox(height: 10),
            if (info['description'] != null)
              Text(
                info['description'].toString().toPersianNum(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
        actions: [
          if (!info['isForcible'])
            TextButton(
              onPressed: () {
                isUpdateDialogOpen = false;
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (!isCloseSplashScreen) {
                    replaceSplashPage(const HomePage());
                  }
                });
              },
              child: Text(
                Strs.remindMeLater,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              url.launchUrl(
                Uri.parse(info['downloadUrl']),
                mode: url.LaunchMode.externalApplication,
              );
              AppOptions().setIsHaveForceUpdate(false);
            },
            child: Text(
              Strs.update,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ),
        ],
      );
    },
  );
}

void showDialogUpdatePlease() {
  isUpdateDialogOpen = true;
  showGeneralDialog(
    context: navKey.currentContext!,
    pageBuilder: (context, animation, secondaryAnimation) {
      return AlertDialog(
        scrollable: true,
        insetPadding: const EdgeInsets.symmetric(vertical: 100),
        icon: Icon(
          Icons.update_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        title: Row(
          children: [
            Text(
              Strs.titleUpdateMsg,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Strs.updatePlease,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    },
  );
}

void openHintPage() {
  showModalBottomSheet(
    context: navKey.currentContext!,
    barrierColor: Colors.transparent,
    isDismissible: false,
    // enableDrag: true,
    isScrollControlled: true,
    builder: (context) {
      return HintPage();
    },
  );
}
