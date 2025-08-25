import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_metro/forgot_password/reset_password.dart';

class OtpVerifyScreen extends StatefulWidget {
  @override
  _OtpVerifyScreenState createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  int _secondRemaining = 60;
  Timer? _timer;

  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _checkOtpFields() {
    setState(() {
      isButtonActive =
          otpControllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  void _startTimer() {
    _secondRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondRemaining > 0) {
        setState(() {
          _secondRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _verifyOTP() {
    String enteredOTP =
    otpControllers.map((controller) => controller.text).join();
    if (enteredOTP == "123456") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 20),
              const Text(
                "OTP Verified\nSuccessfully",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        navigate();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid OTP")));
    }
  }

  void navigate() {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
  }

  void _resendOTP() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    setState(() {
      isButtonActive = false;
    });
    _startTimer();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Resent OTP")));
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;
    final surfaceVariant = theme.colorScheme.surfaceVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("SMS Code", style: theme.textTheme.titleLarge?.copyWith(color: primary)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  child: TextField(
                    controller: otpControllers[index],
                    focusNode: focusNodes[index],
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (index < 5) {
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      }
                      _checkOtpFields();
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primary, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: primary, width: 2),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 60),

            // Timer Circle
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: _secondRemaining / 60,
                    strokeWidth: 6,
                    color: primary,
                    backgroundColor: surfaceVariant,
                  ),
                ),
                Text(
                  "$_secondRemaining",
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Verify Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonActive ? primary : primary.withOpacity(0.6),
                minimumSize: const Size(280, 60),
              ),
              onPressed: isButtonActive ? _verifyOTP : null,
              child: Text(
                "Verify",
                style: theme.textTheme.labelLarge?.copyWith(color: onPrimary),
              ),
            ),
            const SizedBox(height: 40),

            // Resend OTP Button
            if (_secondRemaining == 0)
              ElevatedButton(
                onPressed: _resendOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.background,
                  minimumSize: const Size(280, 50),
                  side: BorderSide(color: primary),
                ),
                child: Text(
                  "Resend OTP",
                  style: TextStyle(color: primary, fontWeight: FontWeight.w600),
                ),
              ),

            const SizedBox(height: 60),

            // Cancel Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(200, 50),
                side: BorderSide(color: primary, width: 2),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: primary, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
