import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_options.dart';
import 'app_theme_data.dart';
import 'commands_controller.dart';
import 'pages/levels/level_controller.dart';
import 'pages/splash_page.dart';
import 'sounds_controller.dart';
import 'strs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initControllers();

  runApp(
    ChangeNotifierProvider<ThemeChangeNotifier>(
      create: (_) => ThemeChangeNotifier(AppOptions().isDarkMode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: Provider.of<ThemeChangeNotifier>(context).themeMode,
      theme: AppThemeData.lightThemeData,
      darkTheme: AppThemeData.darkThemeData,
      title: Strs.appName,
      builder: (context, child) {
        AppOptions().context = context;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const SplashPage(),
    );
  }
}

Future<void> initControllers() async {
  sp = await SharedPreferences.getInstance();
  AppOptions();
  SoundsController();
  LevelController().setCurrentLevel(AppOptions().level);
  CommandsController();
}
