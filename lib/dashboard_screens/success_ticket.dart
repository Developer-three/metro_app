import 'package:flutter/material.dart';
import 'package:task_metro/dashboard_screens/qr_ticket.dart';

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
  State<TicketSuccesScreen> createState() => _TicketSuccesScreenState();
}

class _TicketSuccesScreenState extends State<TicketSuccesScreen> {
  @override
  void initState() {
    super.initState();
    _successnavigate();
  }

  void _successnavigate() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QRTicketScreen(
            fromStation: widget.fromStation,
            toStation: widget.toStation,
            journeyType: widget.journeyType,
            tickets: widget.tickets,
            qrData: widget.qrData,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ Green success circle
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade700, width: 8),
                  ),
                  child: const Icon(Icons.check, size: 70, color: Colors.green),
                ),
                const SizedBox(height: 32),

                // ✅ Themed text styles
                Text(
                  "Successful",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ticket Purchase",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 400),

                // ✅ Outlined Button with theme
                SizedBox(
                  width: 280,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
                      ),
                      side: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                    onPressed: () {
                      // Optional manual nav, if needed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRTicketScreen(
                            fromStation: widget.fromStation,
                            toStation: widget.toStation,
                            journeyType: widget.journeyType,
                            tickets: widget.tickets,
                            qrData: widget.qrData,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Go to QR Tickets",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ✅ Close text button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Close",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      decoration: TextDecoration.underline,
                      color: colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
