import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_options.dart';
import 'app_theme_data.dart';
import 'commands_controller.dart';
import 'pages/home_page.dart';
import 'strs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sp = await SharedPreferences.getInstance();
  CommandsController();

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
      home: const HomePage(),
    );
  }
}
