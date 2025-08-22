import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:task_metro/dashboard_screens/bottom_navigation.dart';

class QRTicketScreen extends StatelessWidget {
  final String fromStation;
  final String toStation;
  final String journeyType;
  final int tickets;
  final String qrData;

  const QRTicketScreen({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.journeyType,
    required this.tickets,
    required this.qrData, // ✅ fixed this line
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String ticketNumber = (Random().nextInt(9000) + 1000).toString();
    final String validTill = "${now.day}.${now.month}.${now.year}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F4F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 29),
                    QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 320,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(30),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 32,
                      endIndent: 32,
                      color: Colors.grey.shade400,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_pin, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                fromStation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(Icons.location_pin, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                toStation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Ticket Type: $journeyType",
                            style: const TextStyle(
                              wordSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Number of Tickets: $tickets",
                            style: const TextStyle(
                              wordSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Valid till: $validTill",
                            style: const TextStyle(
                              wordSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ticket No: $ticketNumber",
                            style: const TextStyle(
                              wordSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, color: Colors.black87, size: 40),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "This ticket includes a return journey as well, "
                          "please keep your ticket till the end of your return journey.",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange, width: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GNavigation(selectedIndex: 1),
                      ),
                          (route) => false,
                    );
                  },
                  child: const Text(
                    "Back to My Tickets",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
