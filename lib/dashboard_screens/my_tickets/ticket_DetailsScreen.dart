import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:task_metro/dashboard_screens/my_tickets/ticket_modal.dart';
import 'package:task_metro/theme/app_theme.dart';

class TicketDetailsScreen extends StatelessWidget {
  final TicketModel ticket;

  const TicketDetailsScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Ticket Details"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
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
                      data: ticket.qrData,
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
                                ticket.fromStation,
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
                                ticket.toStation,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Ticket Type: ${ticket.journeyType}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Number of Tickets: ${ticket.tickets}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Valid till: ${ticket.validTill}",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                              wordSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Ticket No: ${ticket.ticketId}",
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
            ],
          ),
        ),
      ),
    );
  }
}
