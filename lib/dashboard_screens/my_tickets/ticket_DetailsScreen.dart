import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';  // Add qr_flutter in pubspec.yaml

import 'ticket_modal.dart';

class TicketDetailsScreen extends StatelessWidget {
  final TicketModel ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    // Agar TicketModel me qrData nahi hai, toh generate kar sakte ho ticketNumber ya koi unique string se
    final qrData = ticket.qrData;  // Ya agar ticket.qrData hai use karo

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('From: ${ticket.fromStation}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('To: ${ticket.toStation}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Journey Type: ${ticket.journeyType}'),
                      Text('Valid Till: ${ticket.validTill}'),
                      Text('Ticket No: ${ticket.ticketNumber}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
        
               QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250,
                gapless: false,
              ),
              const SizedBox(height: 24),
              const Text(
                'Show this QR code at the station',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
