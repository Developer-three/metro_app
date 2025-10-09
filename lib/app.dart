import 'package:flutter/material.dart';
import 'package:task_metro/screens/login_screen.dart';
import 'package:task_metro/screens/splash_screen.dart';
import 'package:task_metro/theme/app_theme.dart';
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
      title: 'Agra Metro',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: AppTheme.lightTheme, // ✅ Apply your custom theme
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
      },
    );
  }
}
