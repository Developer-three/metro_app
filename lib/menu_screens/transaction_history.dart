import 'package:flutter/material.dart';
import 'package:task_metro/theme/app_theme.dart';

import '../dashboard_screens/my_tickets/ticket_DetailsScreen.dart';
import '../dashboard_screens/my_tickets/ticket_modal.dart';
import '../db_helper/ticket_database.dart';

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String? startDate;
  String? endDate;

  List<TicketModel> availableTickets = [];
  List<TicketModel> usedTickets = [];

  // Filter button states
  String? selectedTimeFilter;
  String? selectedTypeFilter;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        final formatted = "${picked.day}/${picked.month}/${picked.year}";
        if (isStart) {
          startDate = formatted;
        } else {
          endDate = formatted;
        }

      });
    }
  }

  void didChangeDependencies(){
    super.didChangeDependencies();
    _loadTicketsFromDB();
  }

  Future<void> _loadTicketsFromDB() async {
    availableTickets =
    await TicketDatabase.instance.fetchTickets(isUsed: false);
    usedTickets = await TicketDatabase.instance.fetchTickets(isUsed: true);
    setState(() {});
  }


    void _toggleTimeFilter(String value) {
      setState(() {
        if (selectedTimeFilter == value) {
          selectedTimeFilter = null; // Deselect if already selected
        } else {
          selectedTimeFilter = value;
        }
      });
    }

    void _toggleTypeFilter(String value) {
      setState(() {
        if (selectedTypeFilter == value) {
          selectedTypeFilter = null; // Deselect
        } else {
          selectedTypeFilter = value;
        }
      });
    }

    Widget _filterButton(String text,
        bool isSelected,
        VoidCallback onTap,
        ColorScheme colorScheme,
        TextTheme textTheme,) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : colorScheme.surface,
            border: Border.all(color: colorScheme.outline, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }



    final List<Map<String, String>> transactions = [
      {
        "title": "Ticket Use",
        "subtitle": "1 Adult Raja Ki Mandi Station",
        "date": "01-11-2023 09:48:12"
      },
      {
        "title": "Ticket Use",
        "subtitle": "1 Adult Sadat Bazar Station",
        "date": "19-10-2023 09:48:12"
      },
      {
        "title": "Ticket Use",
        "subtitle": "1 Adult Raja Ki Mandi Station",
        "date": "01-11-2023 09:48:12"
      },
      {
        "title": "Ticket Use",
        "subtitle": "1 Adult Sadat Bazar Station",
        "date": "19-10-2023 09:48:12"
      },
    ];

    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final textTheme = theme.textTheme;
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Transaction History",
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Date pickers
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: colorScheme.primary, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          startDate ?? "DD/MM/YYYY",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: colorScheme.primary, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          endDate ?? "DD/MM/YYYY",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurface),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Time filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _filterButton(
                    "Last 24h",
                    selectedTimeFilter == "Last 24h",
                        () => _toggleTimeFilter("Last 24h"),
                    colorScheme,
                    textTheme,
                  ),
                  _filterButton(
                    "Last week",
                    selectedTimeFilter == "Last week",
                        () => _toggleTimeFilter("Last week"),
                    colorScheme,
                    textTheme,
                  ),
                  _filterButton(
                    "Last 30d",
                    selectedTimeFilter == "Last 30d",
                        () => _toggleTimeFilter("Last 30d"),
                    colorScheme,
                    textTheme,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              /// Type filters
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _filterButton(
                    "Ticket Use",
                    selectedTypeFilter == "Ticket Use",
                        () => _toggleTypeFilter("Ticket Use"),
                    colorScheme,
                    textTheme,
                  ),
                  _filterButton(
                    "Ticket Purchase",
                    selectedTypeFilter == "Ticket Purchase",
                        () => _toggleTypeFilter("Ticket Purchase"),
                    colorScheme,
                    textTheme,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Transactions list
              ...[
                ...usedTickets.reversed.take(5).map((ticket) {
                  return Card(
                    elevation: 5,
                    color: AppTheme.secondaryColor,
                    child: ListTile(
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                      ),
                      title: Text(
                        "${ticket.fromStation} - to\n${ticket
                            .toStation}\n${ticket.validTill}",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall,
                      ),
                      subtitle: Text(
                        "Price: 30.00",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: Text(
                        "Order ID:${ticket.orderId}\n"
                            "Trans ID:${ticket.transactionId}\n"
                            "Ticket Id:${ticket.ticketId}",
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          fontWeight: FontWeight.w500,
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
      );
    }
  }


