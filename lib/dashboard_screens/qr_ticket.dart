import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:task_metro/dashboard_screens/bottom_navigation.dart';
import 'package:task_metro/theme/app_theme.dart';
import '../db_helper/ticket_database.dart';
import 'my_tickets/ticket_modal.dart';

class QRTicketScreen extends StatefulWidget {
  final String fromStation;
  final String toStation;
  final String journeyType;
  final int tickets;
  final String ticketId;
  final String orderId;
  final String transactionId;
  final String qrData;

  const QRTicketScreen({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.journeyType,
    required this.tickets,
    required this.transactionId,
    required this.orderId,
    required this.ticketId,
    required this.qrData,
  });

  @override
  State<QRTicketScreen> createState() => _QRTicketScreenState();
}

class _QRTicketScreenState extends State<QRTicketScreen> {
  late final String validTill;
  bool _ticketSaved = false;

  @override
  void initState() {
    super.initState();

    // ✅ CHANGED: use formatted date (DD.MM.YYYY) instead of ISO string
    final now = DateTime.now();
    validTill = DateFormat('dd-MM-yyyy HH:mm')
        .format(DateTime.now().add(const Duration(seconds: 10)));

    _saveTicket();
  }

  Future<void> _saveTicket() async {
    if (_ticketSaved) return;

    _ticketSaved = true; // Avoid double-insertion

    final ticket = TicketModel(
      fromStation: widget.fromStation,
      toStation: widget.toStation,
      journeyType: widget.journeyType,
      tickets: widget.tickets,
      ticketId: widget.ticketId,
      transactionId: widget.transactionId,
      orderId: widget.orderId,
      validTill: validTill, // ✅ CHANGED: Corrected formatting
      qrData: widget.qrData,
    );

    await TicketDatabase.instance.insertTicket(ticket);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.thirdColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 29),
                    QrImageView(
                      data: widget.qrData,
                      version: QrVersions.auto,
                      size: 320,
                      backgroundColor: colorScheme.background,
                      padding: const EdgeInsets.all(30),
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 32,
                      endIndent: 32,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_pin, size: 20, color: colorScheme.primary),
                              const SizedBox(width: 6),
                              Text(
                                widget.fromStation,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Icon(Icons.location_pin, size: 20, color: colorScheme.primary),
                              const SizedBox(width: 6),
                              Text(
                                widget.toStation,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Ticket Type: ${widget.journeyType}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Number of Tickets: ${widget.tickets}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Valid till: $validTill", // ✅ CHANGED
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ticket No: ${widget.ticketId}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Transaction ID: ${widget.transactionId}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Order ID: ${widget.orderId}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
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
                children: [
                  Icon(Icons.info_outline, color: colorScheme.onSurface.withOpacity(0.8), size: 40),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "This ticket includes a return journey as well, "
                          "please keep your ticket till the end of your return journey.",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
                    side: BorderSide(color: colorScheme.primary, width: 3),
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
                  child: Text(
                    "Back to My Tickets",
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
