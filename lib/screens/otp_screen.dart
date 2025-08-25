import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_metro/screens/login_screen.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  int _secondRemaining = 60;
  Timer? _timer;

  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _checkOtpFileds() {
    setState(() {
      isButtonActive =
          otpControllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  void _startTimer() {
    _secondRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
              Icon(Icons.check_circle,
                  color: Colors.green, size: 60),
              SizedBox(height: 20),
              Text(
                "Your Account is\nSuccessfully Created",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
      Future.delayed(Duration(seconds: 2), () {
        navigate();
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid OTP")));
    }
  }

  void navigate() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
        .showSnackBar(SnackBar(content: Text("Resent OTP")));
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpControllers.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SMS Code",
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: 15),
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
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      }
                      _checkOtpFileds();
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 60),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: _secondRemaining / 60,
                    strokeWidth: 6,
                    color: theme.primaryColor,
                    backgroundColor: theme.disabledColor.withOpacity(0.2),
                  ),
                ),
                Text(
                  "$_secondRemaining",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonActive
                    ? theme.primaryColor
                    : theme.disabledColor,
                minimumSize: Size(280, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: isButtonActive ? _verifyOTP : null,
              child: Text(
                "Verify",
                style: theme.textTheme.labelLarge,
              ),
            ),
            SizedBox(height: 40),
            if (_secondRemaining == 0)
              OutlinedButton(
                onPressed: _resendOTP,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(280, 50),
                  side: BorderSide(color: theme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Resend OTP",
                  style: TextStyle(color: theme.primaryColor),
                ),
              ),
            SizedBox(height: 60),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: Size(200, 50),
                side: BorderSide(color: theme.primaryColor, width: 2.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
