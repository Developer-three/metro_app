import 'package:flutter/material.dart';
import 'package:task_metro/screens/splash_screen.dart';
import 'package:task_metro/theme/app_theme.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agra Metro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // ✅ Apply your custom theme
      initialRoute: AppRoutes.login,
      routes: {AppRoutes.login: (context) => SplashScreen()},
    );
  }
}
