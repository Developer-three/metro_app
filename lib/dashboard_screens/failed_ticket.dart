import 'package:flutter/material.dart';
import 'package:task_metro/dashboard_screens/home_page.dart';

class TicketFailedScreen extends StatelessWidget {
  const TicketFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.error, width: 4),
                  ),
                  child: Icon(
                    Icons.close,
                    size: 70,
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Failed",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ticket Purchase",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "There was an error with your payment.\n"
                      "Please check your payment info and try again",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onBackground.withOpacity(0.6)),
                ),
                const SizedBox(height: 40),
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context)=>DashBoardScreen()));
                    },
                    child: Text(
                      "Go Back to Buy Tickets",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Optionally you can add a close button or any other widget here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
