import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_metro/dashboard_screens/failed_ticket.dart';
import 'package:task_metro/dashboard_screens/success_ticket.dart';
import 'package:http/http.dart' as http;



import 'my_tickets/tickets_page.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectIndex=0;
  final List<Widget> _screens = [
    Center(child: Text("Home ")),
    Center(child: Text("My Tickets")),
    Center(child: Text("Line Map")),
    Center(child: Text("Menu")),
  ];
  String fromStation = "Sikandra";
  String toStation = "Hing ki Mandi";
  int tickets = 1;
  String journeyType = "One-way";

  final Map<String, String> stationCodes = {
    "Sikandra": "01",
    "Ambedkar University": "02",
    "RBS College": "03",
    "Raja ki Mandi": "04",
    "St John’s (Agra University)": "05",
    "Medical College": "06",
    "Hing ki Mandi": "07",
    "Jama Masjid": "08",
    "Agra Fort": "09",
    "Taj Mahal": "10",
    "Sadat Bazar": "11",
    "Basai": "12",
  };
  bool isloading=false;


  Future<void> sendTicketRequest() async {
    final String? fromCode = stationCodes[fromStation];
    final String? toCode = stationCodes[toStation];

    if (fromCode == null || toCode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid station selection")),
      );
      return;
    }

    setState(() {
      isloading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("http://192.168.1.63:10000/api/v1/generate-ticket"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "source": fromCode,
          "destination": toCode,
          "quantity": tickets.toString(),
          "productId": journeyType == "One-way" ? "06" : "07"
          ,
          "paymentMode" : "UPI"
        }),
      );

      setState(() {
        isloading = false;
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        final qrString = data['qrData'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketSuccesScreen(
              fromStation: fromStation,
              toStation: toStation,
              journeyType: journeyType,
              tickets: tickets,
              qrData: qrString, // ✅ pass QR string
            ),
          ),
        );
      } else {
        print("Server Error: ${response.body}");
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TicketFailedScreen()));
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print("API Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. Try again later.")),
      );
    }
  }



  final List<String> stations = [
    "Sikandra",
    "Ambedkar University",
    "RBS College",
    "Raja ki Mandi",
    "St John’s (Agra University)",
    "Medical College",
    "Hing ki Mandi",
    "Jama Masjid",
    "Agra Fort",
    "Taj Mahal",
    "Sadat Bazar",
    "Basai",
  ];

  List<Map<String, String>> transactions = [
    {
      "type": "use",
      "detail": "1 Adult Raja Ki Mandi Station",
      "date": "01-11-2023 09:48:12"
    },
    {
      "type": "purchase",
      "detail": "1 Adult Raja Ki Mandi - Basai",
      "date": "01-11-2023 09:47:35"
    },
    {
      "type": "purchase",
      "detail": "2 Adult Basai - Raja Ki Mandi",
      "date": "23-10-2023 16:41:35"
    },
    {
      "type": "use",
      "detail": "1 Adult Sadat Bazar Station",
      "date": "19-10-2023 09:48:12"
    },
  ];

  bool _validateStations() {
    if (fromStation == toStation) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text("Invalid Selection"),
            content: const Text("From and To stations cannot be the same."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Journey Card
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Card(
                  color: Colors.orange,
                  child: Padding(
                    padding: const EdgeInsets.all(37.0),
                    child: Column(
                      children: [
                        // White card section
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              DropdownButtonFormField<String>(
                                dropdownColor: Colors.white,
                                value: fromStation,
                                decoration: const InputDecoration(labelText: "From"),

                                items: stations
                                    .map((station) => DropdownMenuItem(
                                  value: station,
                                  child: Text(station),
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    fromStation = val!;
                                    _validateStations();
                                  });
                                },
                              ),

                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                dropdownColor: Colors.white,
                                value: toStation,
                                decoration: const InputDecoration(labelText: "To"),
                                items: stations
                                    .map((station) => DropdownMenuItem(
                                  value: station,
                                  child: Text(station),
                                ))
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    toStation = val!;
                                    _validateStations();
                                  });
                                },
                              ),
                              const SizedBox(height: 1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        "Number of tickets",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              if (tickets > 1) {
                                                setState(() {
                                                  tickets--;
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.remove_circle_outline),
                                            padding: EdgeInsets.zero, // Remove extra padding
                                            constraints: BoxConstraints(), // Remove default button constraints
                                          ),
                                          Text("$tickets"),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                tickets++;
                                              });
                                            },
                                            icon: const Icon(Icons.add_circle_outline),
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // Journey type
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            activeColor: Colors.orange,
                                            value: "One-way Journey",
                                            groupValue: journeyType,
                                            onChanged: (val) {
                                              setState(() {
                                                journeyType = val.toString();
                                              });
                                            },
                                          ),
                                          const Text("One-way Journey"),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            activeColor: Colors.orange,
                                            value: "Return Journey Ticket",
                                            groupValue: journeyType,
                                            onChanged: (val) {
                                              setState(() {
                                                journeyType = val.toString();
                                              });
                                            },
                                          ),
                                          const Text("Return Journey"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Container(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                          ),
                          child: Row(
                            children:[
                              //Left side total fare
                              Expanded(
                                child: Container(
                                // padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Total Fare",
                                    style:TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w600)
                                      ),
                                    SizedBox(height: 4),
                                    Text("₹ 30.00",style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black
                                    ),
                                    ),
                                  ],
                                ),
                              ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:BorderRadiusGeometry.circular(30),
                                        side: BorderSide(color: Colors.orange)
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: (){

                                     if(_validateStations()){
                                       sendTicketRequest();
                                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>TicketSuccesScreen(
                                       //   fromStation: fromStation,       // ✅ passed value
                                       //   toStation: toStation,           // ✅ passed value
                                       //   journeyType: journeyType,       // ✅ passed value
                                       //   tickets: tickets,
                                       //   qrData:qrData,
                                       // )));
                                     }

                                      },
                                  icon: Icon(
                                    Icons.confirmation_num,color: Colors.orange,
                                    size: 28,
                                  ),
                                    label:Text("By QR Tickets",

                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                      ),
                                    ),
                                ),

                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Transactions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Latest Transactions",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...transactions.map((t) {
                      return Card(
                        color: t["type"] == "use" ? Colors.green.shade100 : Colors.grey.shade200,
                        child: ListTile(
                          leading: Icon(
                            t["type"] == "use"
                                ? Icons.qr_code_scanner
                                : Icons.check_circle_outline,
                            color: Colors.orange,
                          ),
                          title: Text(t["detail"]!),
                          subtitle: Text(t["date"]!),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Show more",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

}
