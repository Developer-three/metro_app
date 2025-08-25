import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_metro/screens/otp_screen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Email Regex
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // First Name
                TextFormField(
                  controller: _firstNameController,
                  decoration: _inputDecoration("First Name", Icons.person_outline, theme),
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    LengthLimitingTextInputFormatter(15),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'First name is required';
                    } else if (value.length > 15) {
                      return 'Max 15 characters allowed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // Last Name
                TextFormField(
                  controller: _lastNameController,
                  decoration: _inputDecoration("Last Name", Icons.person, theme),
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    LengthLimitingTextInputFormatter(15),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Last name is required';
                    } else if (value.length > 15) {
                      return 'Max 15 characters allowed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration("Phone", Icons.phone, theme),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration("Email", Icons.email_outlined, theme),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    } else if (!_emailRegex.hasMatch(value.trim())) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    "Password",
                    Icons.lock_outline,
                    theme,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Signup Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "OTP Sent Successfully on your Number",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: Colors.green.shade700, // success green color
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OTPScreen()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "All fields are required",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: colorScheme.error,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Already a member? Login
                Column(
                  children: [
                    Text(
                      "Already a member?",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 140,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.primary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
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

  InputDecoration _inputDecoration(String hint, IconData icon, ThemeData theme,
      {Widget? suffixIcon}) {
    final colorScheme = theme.colorScheme;
    return InputDecoration(
      prefixIcon: Icon(icon, color: colorScheme.primary),
      suffixIcon: suffixIcon,
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
