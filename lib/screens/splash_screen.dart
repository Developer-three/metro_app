import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:task_metro/dashboard_screens/home_page.dart';
import 'package:task_metro/screens/login_screen.dart';
import 'package:task_metro/theme/app_theme.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../routes/app_routes.dart';
import 'no_internet_page.dart'; // Replace with your actual home page import

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

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

  Future<void>_checkInternetAndNavigate()async{
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = connectivityResult != ConnectivityResult.none;
    if(!mounted)return;

    if(hasConnection && await _hasActiveInternet()){
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }else{
      setState(() {
        _hasInternet = false;
      });
    }

  }
  Future<bool> _hasActiveInternet()async{
    try{
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch(_){
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!_hasInternet){
      return NoInternetPage(
        onRetry: (){
          setState(() {
            _hasInternet=true;
          });
          _checkInternetAndNavigate();
        }
      );
    }
    return Scaffold(
      backgroundColor: AppTheme.primaryColor, // Set splash background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Splash Logo/Image
            Image.asset(
              'assets/upmrc.png', // Make sure you add the image in your assets folder and pubspec.yaml
              height: 120,
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
