import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_verify_screen.dart';

class EnterMobileScreen extends StatefulWidget {
  const EnterMobileScreen({super.key});

  @override
  State<EnterMobileScreen> createState() => _EnterMobileScreenState();
}

class _EnterMobileScreenState extends State<EnterMobileScreen> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // 🔑 Important for validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                "Please enter your mobile number to reset your password",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_android),
                  hintText: "+91 1234-56789",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.orange, width: 2),
                  ),
                ),
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
              const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(style:ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ) ,
                      onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          // ✅ Valid input
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Sending OTP to ${phoneController.text}')),
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpVerifyScreen()),);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Field is required')),
                          );
                        }

                      }, child: Text("Send SMS Code",style: TextStyle(fontSize: 18,color: Colors.white),
                      ),
                  ),
                ),
                 SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(style: OutlinedButton.styleFrom(
                    shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(25),
                    ),
                  side: BorderSide(color: Colors.orange),
                ),onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Cancel",style: TextStyle(fontSize: 16,color: Colors.black),)),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
