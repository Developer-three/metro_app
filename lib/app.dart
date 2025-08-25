import 'package:flutter/material.dart';
import 'package:task_metro/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'screens/login_screen.dart';
import 'theme/theme_app.dart'; // ✅ Import the custom theme file

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agra Metro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // ✅ Apply your custom theme
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
      },
    );
  }
}
