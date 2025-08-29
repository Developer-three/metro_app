import 'dart:async';
import 'dart:io'; // ✅ Needed for InternetAddress

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:task_metro/screens/login_screen.dart';
import '../theme/app_theme.dart';
import 'no_internet_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _checkInternetAndNavigate();
  }

  // ✅ Combined connectivity and actual internet check
  Future<void> _checkInternetAndNavigate() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = connectivityResult != ConnectivityResult.none;

    if (!mounted) return;

    if (hasConnection && await _hasActiveInternet()) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      setState(() {
        _hasInternet = false;
      });
    }
  }

  // ✅ Real internet check (DNS lookup)
  Future<bool> _hasActiveInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return NoInternetPage(
        onRetry: () {
          setState(() {
            _hasInternet = true; // Show splash again while retrying
          });
          _checkInternetAndNavigate();
        },
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/upmrc.png', height: 120),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: AppTheme.secondaryColor),
          ],
        ),
      ),
    );
  }
}
