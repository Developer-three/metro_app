import 'package:flutter/material.dart';
import 'package:task_metro/theme/app_theme.dart';

class TransactionHistoryScreen extends StatefulWidget {
  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String? startDate;
  String? endDate;

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

  Widget _filterButton(
      String text,
      bool isSelected,
      VoidCallback onTap,
      ColorScheme colorScheme,
      TextTheme textTheme,
      ) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  var tx = transactions[index];

                  // Optional: filter logic (example)
                  if (selectedTypeFilter != null &&
                      tx["title"] != selectedTypeFilter) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.thirdColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.qr_code,
                            size: 28, color: colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx["title"]!,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tx["subtitle"]!,
                                style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          tx["date"]!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
