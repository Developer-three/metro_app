import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_metro/screens/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget{
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState()=> _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>{

  final _formKey=GlobalKey<FormState>();
  final _passwordController=TextEditingController();
  final _confirmPasswordController=TextEditingController();

  bool _obsecurePassword=true;
  bool _obsecureConfirmPassword=true;
  bool _isButtonEnabled=false;


  void _validatePassword(){
    setState(() {
      _isButtonEnabled=_passwordController.text.isNotEmpty
          && _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text==_confirmPasswordController.text;

    });
  }
  void _showSuccessDialog(){
    showDialog(context: context, builder: (ctx)=>
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle,color:Colors.green,size: 60),
          SizedBox(height: 12),
          Text("Your Password is\nSuccessfully Changed",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(ctx), child:Text("Ok")
        ),
      ],
    )
    );
    Future.delayed(Duration(seconds: 2),(){
      navigate();
    });
  }
  void navigate(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
  }
  @override
  void dispose(){
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(20),
      child: Form(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Please enter your new password.",style:
            TextStyle(fontSize: 28,fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 30),
          TextFormField(
            controller: _passwordController,
            obscureText: _obsecurePassword,
            onChanged: (_)=>_validatePassword(),
            decoration: InputDecoration(
              labelText: "New Password",
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon:Icon(_obsecurePassword?Icons.visibility:Icons.visibility_off),
                onPressed: (){
                setState(() => _obsecurePassword=!_obsecurePassword);
              }
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color:Colors.orange,width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                BorderSide(color: Colors.orange, width: 2),
              ),
            ),
          ),
          SizedBox(height: 25),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obsecureConfirmPassword,
            onChanged: (_)=>_validatePassword(),
            decoration: InputDecoration(
                labelText: "Re-enter New Password",
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon:Icon(_obsecurePassword?Icons.visibility:Icons.visibility_off),
                  onPressed: (){
                    setState(() =>
                    _obsecurePassword=!_obsecurePassword);
                    },
                ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color:Colors.orange,width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                BorderSide(color: Colors.orange, width: 2),
              ),
            ),
          ),
            SizedBox(height: 30),
            ElevatedButton(onPressed: _isButtonEnabled?_showSuccessDialog:null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled?Colors.orange:Colors.grey,
                  minimumSize: Size(250, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
                ),
                child: Text("Create New Password",style: TextStyle(
                  fontSize: 16,fontWeight: FontWeight.w600,
                  color: Colors.white
                ),
                ),
            ),
          SizedBox(height: 50),
          //Cancel Button
          OutlinedButton(onPressed:()=>Navigator.pop(context) ,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color:Colors.orange),
                minimumSize: Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )
              ),

              child:Text("Cancel",style: TextStyle(color: Colors.black),) )
        ],
      )),

      ),
    );
  }

}