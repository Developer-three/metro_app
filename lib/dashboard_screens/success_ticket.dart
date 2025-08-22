import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_metro/dashboard_screens/home_page.dart';
import 'package:task_metro/dashboard_screens/qr_ticket.dart';
import 'package:task_metro/screens/login_screen.dart';

class TicketSuccesScreen extends StatefulWidget {
  final String fromStation;
  final String toStation;
  final String journeyType;
  final int tickets;
  final String qrData;

  const TicketSuccesScreen({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.journeyType,
    required this.tickets,
    required this.qrData,

  });

  @override
  State<StatefulWidget> createState()=>_TicketSuccesScreenState();
}

class _TicketSuccesScreenState extends State<TicketSuccesScreen> {

  @override
  void initState(){
    super.initState();
    _successnavigate();
  }
  void _successnavigate(){
    Future.delayed(Duration(seconds: 3),(){
      //Navigate to qrTicket
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>QRTicketScreen(
        fromStation: widget.fromStation,
        toStation: widget.toStation,
        journeyType: widget.journeyType,
        tickets: widget.tickets,
        qrData:widget.qrData
      )));
    });
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child:
      Center(
        child:
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  border: Border.all(color: Colors.green.shade700, width: 8),
                ),
                child: Icon(Icons.check
                  , size: 70, color: Colors.green,
                ),
              ),
              SizedBox(height: 32),
              Text("Successful", style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500
              ),
              ),
              SizedBox(height: 4),
              Text("Ticket Purchase",
                style: TextStyle(fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),


              SizedBox(height: 400),
              //Go back Button
              SizedBox(
                width: (280),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(38),

                    ),
                    side: BorderSide(color: Colors.orange, width: 2),
                  ),
                  onPressed: () {

                  },

                  child: Text("Go to QR Tickets",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(onPressed: () {
                Navigator.pop(context);
              },
                child: Text("Close", style: TextStyle(fontSize: 15,
                    decoration: TextDecoration.underline,
                    color: Colors.black87),),),

            ],
          ),

        ),
      ),
      ),
    );
  }
}
