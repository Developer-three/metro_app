import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_metro/screens/otp_screen.dart';
import 'package:task_metro/theme/theme_app.dart';
import 'forgot_password/enter_mobile_screen.dart';
import'routes/app_routes.dart';
import 'screens/login_screen.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agra Metro',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,           // 👈 your custom light theme
      darkTheme: darkTheme,        // 👈 your custom dark theme
      themeMode: ThemeMode.system, // 👈 auto-switches based on device
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login:(context)=> const LoginScreen()
      },
    );
  }

}