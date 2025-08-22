import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketFailedScreen extends StatelessWidget{
  const TicketFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       body: SafeArea(child:
       Center(
         child:
         Padding(
             padding:EdgeInsets.symmetric(horizontal: 24.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 height: 120,
                 width: 120,
                 decoration: BoxDecoration(shape: BoxShape.circle,
                 border: Border.all(color: Colors.red,width: 4),
                 ),
                 child: Icon(Icons.close,size: 70,color: Colors.red
                 ),
               ),
               SizedBox(height: 32),
               Text("Failed",style: TextStyle(
                   fontSize: 20,
                   fontWeight: FontWeight.w500
               ),
               ),
               SizedBox(height: 4),
               Text("Ticket Purchase",
               style: TextStyle(fontSize: 20,
                 fontWeight: FontWeight.w500,
               ),
               ),

               SizedBox(height: 20),
               //Description
               Text("There was an error with your payment.\n"
               "Please check your payment info and try again",
               textAlign: TextAlign.center,
                 style: TextStyle(fontSize: 14,color: Colors.black54),
                  
               ),
               SizedBox(height: 40),
               //Go back Button
               SizedBox(
                 width: (280),
                 child: OutlinedButton(
                     style: OutlinedButton.styleFrom(
                       padding: EdgeInsets.symmetric(vertical: 14),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadiusGeometry.circular(38),

                       ),
                       side: BorderSide(color: Colors.orange,width: 2),
                     ),
                     onPressed: (){
                       Navigator.pop(context);
                     },
                     
                     child: Text("Go Back to Buy Tickets",
                       style: TextStyle(
                         fontSize: 16,
                         color: Colors.black,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                 ),
               ),
               SizedBox(height: 20),
               // TextButton(onPressed: (){Navigator.pop(context);},
               //     child: Text("Close",style: TextStyle(fontSize: 15,decoration: TextDecoration.underline,color: Colors.black87),),),

             ],
           ),

         ),
       ),
       ),
    );
  }

}