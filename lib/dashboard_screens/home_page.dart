import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_metro/dashboard_screens/failed_ticket.dart';
import 'package:task_metro/dashboard_screens/my_tickets/ticket_DetailsScreen.dart';
import 'package:task_metro/dashboard_screens/my_tickets/ticket_modal.dart';
import 'package:task_metro/dashboard_screens/success_ticket.dart';
import 'package:http/http.dart' as http;
import 'package:task_metro/theme/app_theme.dart';

import '../db_helper/ticket_database.dart';
import 'my_tickets/tickets_page.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _selectIndex = 0;
  final List<Widget> _screens = [
    Center(child: Text("Home ")),
    Center(child: Text("My Tickets")),
    Center(child: Text("Line Map")),
    Center(child: Text("Menu")),
  ];
  String fromStation = "Sikandra";
  String toStation = "Hing ki Mandi";
  int tickets = 1;
  String journeyType = "One-way Journey";

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
  bool isloading = false;

  Future<void> sendTicketRequest() async {
    print("Inside the method");
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
     print("Api calling");
    try {
      var response = await http.post(
        Uri.parse("http://192.168.1.47:10000/api/v1/generate-ticket"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "source": fromCode,
          "destination": toCode,
          "quantity": tickets.toString(),
          "productId": journeyType == "One-way Journey" ? "06" : "07",
          "paymentMode": "UPI",
        }),

      );

      setState(() {
        isloading = false;
      });
      print("Api is calling");

      if (response.statusCode == 200) {
        print("$response");
        var data = json.decode(response.body);
        print("$data");
        final qrString = data['qrData'];
        final transactionId = data['transactionId'];
        final orderId = data['orderId'];
        final ticketId = data['ticketId']; // Adjust field names based on API response

        print("qrString is :$qrString");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketSuccesScreen(
              fromStation: fromStation,
              toStation: toStation,
              journeyType: journeyType,
              tickets: tickets,
              orderId: orderId,
              ticketId: ticketId,
              transactionId: transactionId,
              qrData: qrString,
            ),
          ),
        );
      } else {
        print("Server Error: ${response.body}");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TicketFailedScreen()));
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

  List<TicketModel> availableTickets=[];
  List<TicketModel> usedTickets=[];

  void didChangeDependencies(){
    super.didChangeDependencies();
    _loadTicketsFromDB();
  }

  Future<void> _loadTicketsFromDB() async {
    availableTickets = await TicketDatabase.instance.fetchTickets(isUsed: false);
    usedTickets = await TicketDatabase.instance.fetchTickets(isUsed: true);
    setState(() {
    });
  }

  bool _validateStations() {
    if (fromStation == toStation) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            title: Text("Invalid Selection", style: Theme.of(context).textTheme.titleLarge),
            content: Text("From and To stations cannot be the same.", style: Theme.of(context).textTheme.bodyMedium),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Journey Card
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Card(
                color: colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(37.0),
                  child: Column(
                    children: [
                      // White card section
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              dropdownColor: colorScheme.secondary,
                              value: fromStation,
                              decoration: InputDecoration(
                                labelText: "From",
                                labelStyle: textTheme.bodyMedium,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colorScheme.secondary),
                                ),
                              ),
                              items: stations
                                  .map((station) => DropdownMenuItem(
                                value: station,
                                child: Text(station, style: textTheme.bodyMedium),
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
                              dropdownColor: colorScheme.secondary,
                              value: toStation,
                              decoration: InputDecoration(
                                labelText: "To",
                                labelStyle: textTheme.bodyMedium,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: colorScheme.primary),
                                ),
                              ),
                              items: stations
                                  .map((station) => DropdownMenuItem(
                                value: station,
                                child: Text(station, style: textTheme.bodyMedium ),
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
                                    Text(
                                      "Number of tickets",
                                      style: textTheme.bodySmall,
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
                                          icon: Icon(Icons.remove_circle_outline, color: colorScheme.primary),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                        ),
                                        Text("$tickets", style: textTheme.bodyMedium),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              tickets++;
                                            });
                                          },
                                          icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
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
                                          // activeColor: colorScheme.onPrimary,
                                          value: "One-way Journey",
                                          groupValue: journeyType,
                                          onChanged: (val) {
                                            setState(() {
                                              journeyType = val.toString();
                                            });
                                          },
                                        ),
                                        Text(
                                          "One-way Journey",
                                          // style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          // activeColor: colorScheme.onPrimary,
                                          value: "Return Journey Ticket",
                                          groupValue: journeyType,
                                          onChanged: (val) {
                                            setState(() {
                                              journeyType = val.toString();
                                            });
                                          },
                                        ),
                                        Text(
                                          "Return Journey",
                                          // style: textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
                                        ),
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
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: colorScheme.background,
                          borderRadius: const BorderRadius.all(Radius.circular(40)),
                        ),
                        child: Row(
                          children: [
                            //Left side total fare
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorScheme.background,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Total Fare",
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onBackground,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "₹ 30.00",
                                      style: textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onBackground,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.background,
                                  foregroundColor: colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(color: colorScheme.primary),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  if (_validateStations()) {
                                    sendTicketRequest();
                                  }
                                },
                                icon: Icon(
                                  Icons.confirmation_num,
                                  color: colorScheme.primary,
                                  size: 28,
                                ),
                                label: Text(
                                  "Buy QR Tickets",
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
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
                  Text(
                    "Latest Transactions",
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...[
                    ...availableTickets.reversed.take(5).map((ticket) {
                      final now = DateTime.now();
                      final expiry = DateTime.tryParse(ticket.validTill);
                      final isActive = expiry != null && expiry.isAfter(now);

                      return InkWell(onTap: (){
                        Navigator.push(context,MaterialPageRoute
                          (builder: (context)=>TicketDetailsScreen(ticket: ticket)));
                      },
                        child: Card(
                          color: isActive
                              ? AppTheme.thirdColor
                              :AppTheme.thirdColor,
                          child: ListTile(
                            leading: Icon(
                              Icons.qr_code_scanner,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(
                              "Ticket from ${ticket.fromStation} to ${ticket.toStation}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              "Valid till: ${ticket.validTill}",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Text(
                              "Price:30.00\nNo: ${ticket.ticketId}",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    ...usedTickets.reversed.take(5).map((ticket) {
                      return InkWell(onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder:
                            (context)=>TicketDetailsScreen(ticket: ticket)));
                      },
                        child: Card(
                          color: AppTheme.secondaryColor,
                          child: ListTile(
                            leading: Icon(
                              Icons.check_circle_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(
                              "${ticket.fromStation} to ${ticket.toStation}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              "Issue Date-time: ${ticket.validTill}\nPrice: 30.00",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            trailing: Text(
                              "Ticket ID:${ticket.ticketId}\n"
                                  "Trans ID:${ticket.transactionId}\nOrder ID:${ticket.orderId}",

                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),


                  const SizedBox(height: 10),
                 ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
