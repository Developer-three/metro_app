
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_metro/forgot_password/enter_mobile_screen.dart';
import 'package:task_metro/screens/signup_screen.dart' show SignupScreen;

import '../dashboard_screens/bottom_navigation.dart';
import '../dashboard_screens/home_page.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState()=>_LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>{
  bool _obscurePassword=true;

  final TextEditingController _phoneController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();


  bool isButtonActive=false;
   @override
   void initState(){
     super.initState();
     _phoneController.addListener(_validateForm);
     _passwordController.addListener(_validateForm);
   }
   void _validateForm(){
     setState(() {
       isButtonActive=_phoneController.text.isNotEmpty && _passwordController.text.isNotEmpty;
     });
   }
   void dispose(){
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
            onPressed: () => Navigator.of(context).pop(false), // Don't exit
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit app
            child: const Text("Exit"),
          ),
        ],
      ),
    ) ?? false; // return false if dialog is dismissed
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 40),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              //Logo
              Center(
                child: Column(
                  children: [
                    Image.asset("assets/upmrc.png",height: 100,),
                    const SizedBox(height: 10),
                    const Text("UP Metro\nRail Corporation\nAgra Metro", textAlign: TextAlign.center,style:
                    TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500
                    ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welocome",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange
                  ),
                ),
              ),

              const SizedBox(height: 25),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_android_outlined,color: Colors.orange),
                  hintText: "+91 xxxx - nnnnnnn",
                  hintStyle: const TextStyle(color:Colors.grey),
                  contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color:Colors.orange,width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.phone,
                //for only numbers
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline,
                    color: Colors.orange,
                  ),
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ?Icons.visibility_off
                          :Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: (){
                      setState(() {
                        _obscurePassword=!_obscurePassword;
                      });
                    },
                  ),
                  contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16,
                    vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.orange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color:Colors.orange,width: 2),
                    borderRadius: BorderRadius.circular(8),

                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EnterMobileScreen()));
                }, child: const
                Text("Forgot Password?",style: TextStyle(color:Colors.grey,),
                ),
                ),
              ),
              const SizedBox(height: 15),
              //Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:isButtonActive?(){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GNavigation(selectedIndex: 0,)),
                    );

                  }
                  :null, style: ElevatedButton.styleFrom(
                  backgroundColor:isButtonActive?Colors.orange:Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                ),
                  child: const Text("Login",style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              //Signup section
              Column(
                children: [
                  const Text("Not a member yet",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height:10),
                  OutlinedButton(onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>const SignupScreen()),
                    );
                  },style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,vertical: 14),
                    side: const BorderSide(color:Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ), child:const Text("Sign Up", style: TextStyle(color: Colors.black,fontSize: 16),
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