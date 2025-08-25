import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_metro/dashboard_screens/bottom_navigation.dart';
import 'package:task_metro/dashboard_screens/my_tickets/ticket_DetailsScreen.dart';
import 'package:task_metro/dashboard_screens/my_tickets/ticket_modal.dart';
import 'package:task_metro/db_helper/ticket_database.dart';
import 'package:task_metro/theme/app_theme.dart';

class MyTicketsScreen extends StatefulWidget {
  final TicketModel? newTicket;

  const MyTicketsScreen({super.key, this.newTicket});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TicketModel> availableTickets = [];
   List<TicketModel> usedTickets = [];
  late Timer _ticketExpiryTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTicketsFromDB();

    if (widget.newTicket != null) {
      _addTickets(widget.newTicket!);
    }

    _ticketExpiryTimer = Timer.periodic(const Duration(seconds: 30), (_) => _checkExpiredTickets());
  }


  Future<void> _loadTicketsFromDB() async{
    availableTickets=await TicketDatabase.instance.fetchTickets(isUsed: false);
    usedTickets=await TicketDatabase.instance.fetchTickets(isUsed: true);
    setState(() {

    });
  }

  void _checkExpiredTickets() async{
    final now = DateTime.now();

      final expired = availableTickets.where((ticket) {
        final expiry = DateTime.tryParse(ticket.validTill);
        return expiry != null && expiry.isBefore(now);
      }).toList();

      for(var ticket in expired){
        await TicketDatabase.instance.updateTicketUsage(
            ticket.ticketNumber, true);
        availableTickets.remove(ticket);
        usedTickets.add(ticket);
      }
      setState(() {

      });

  }

  @override
  void didUpdateWidget(covariant MyTicketsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.newTicket != null) {
      bool allAlreadyAdded = true;

      for (int i = 0; i < widget.newTicket!.tickets; i++) {
        final newTicketNumber = '${widget.newTicket!.ticketNumber}-$i';
        if (!availableTickets.any((ticket) => ticket.ticketNumber == newTicketNumber)) {
          allAlreadyAdded = false;
          break;
        }
      }

      if (!allAlreadyAdded) {
        _addTickets(widget.newTicket!);
      }
    }
  }

  void _addTickets(TicketModel newTicket) async{
      List<TicketModel> newTickets = List.generate(
        newTicket.tickets,
            (index) => TicketModel(
          fromStation: newTicket.fromStation,
          toStation: newTicket.toStation,
          tickets: 1,
          journeyType: newTicket.journeyType,
          validTill: newTicket.validTill,
          ticketNumber: '${newTicket.ticketNumber}-$index',
              qrData: newTicket.qrData,
        ),
      );

      for(var ticket in newTickets){
        bool alreadyExists=availableTickets.any((t)=>
        t.ticketNumber == ticket.ticketNumber);
        if(!alreadyExists){
          await TicketDatabase.instance.insertTicket(ticket);
          availableTickets.add(ticket);
        }
        setState(() {

        });
      }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ticketExpiryTimer.cancel();
    super.dispose();
  }

  Widget _buildEmptyTicketMessage(String message) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 60, color: colorScheme.primary.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Text("Need tickets?", style: textTheme.bodyMedium?.copyWith(color: colorScheme.secondary)),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GNavigation(
                      selectedIndex: 0,
                      newticket: null,
                    ),
                  ),
                      (route) => false,
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Buy QR Tickets"),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary),
                foregroundColor: colorScheme.onBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(TicketModel ticket) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return InkWell(
       onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketDetailsScreen(ticket: ticket),
        ),
      );
    },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.thirdColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticket.fromStation, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Icon(Icons.arrow_downward, size: 20),
                Text(ticket.toStation, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            // Right
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Unused Tickets: 1", style: textTheme.bodySmall),
                Text(ticket.journeyType, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text("Valid Till: ${ticket.validTill}", style: textTheme.bodySmall),
                Text("Ticket No: ${ticket.ticketNumber}", style: textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
        title: Text(
          'My Tickets',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: colorScheme.onPrimary,
          ),
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onPrimary,
          labelStyle: textTheme.labelLarge,
          unselectedLabelStyle: textTheme.bodyMedium,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
          tabs: const [
            SizedBox(width: 180, child: Tab(text: "Available Tickets")),
            SizedBox(width: 160, child: Tab(text: "Used Tickets")),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          availableTickets.isNotEmpty
              ? ListView.builder(
            itemCount: availableTickets.length,
            itemBuilder: (context, index) => _buildTicketCard(availableTickets[index]),
          )
              : _buildEmptyTicketMessage("You have no available tickets at the moment."),
          usedTickets.isNotEmpty
              ? ListView.builder(
            itemCount: usedTickets.length,
            itemBuilder: (context, index) => _buildTicketCard(usedTickets[index]),
          )
              : _buildEmptyTicketMessage("You have no used tickets at the moment."),
        ],
      ),
    );
  }
}
