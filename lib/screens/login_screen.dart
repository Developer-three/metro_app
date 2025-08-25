import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_metro/forgot_password/enter_mobile_screen.dart';
import 'package:task_metro/screens/signup_screen.dart';
import '../dashboard_screens/bottom_navigation.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);

  }

  void _validateForm() {
    setState(() {
      isButtonActive =
          _phoneController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit the app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Exit"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // easy access

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Column(
                    children: [
                      Image.asset("assets/upmrc.png", height: 100),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Phone Field
                TextField(
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  controller: _phoneController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_android_outlined,
                        color: theme.primaryColor),
                    hintText: "+91 xxxx - nnnnnnn",
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),

                const SizedBox(height: 20),

                // Password Field
                TextField(
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline,
                        color: theme.primaryColor),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: theme.disabledColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnterMobileScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: theme.disabledColor),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isButtonActive
                        ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GNavigation(
                            selectedIndex: 0,
                            newticket: null,
                          ),
                        ),
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonActive
                          ? theme.primaryColor
                          : theme.disabledColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Signup
                Column(
                  children: [
                    Text(
                      "Not a member yet",
                      style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        side: BorderSide(color: theme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
