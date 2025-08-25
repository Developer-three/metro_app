import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:task_metro/dashboard_screens/map_city.dart';
import 'package:task_metro/dashboard_screens/my_tickets/ticket_modal.dart';
import 'package:task_metro/menu_screens/menu_bar.dart';
import 'package:task_metro/dashboard_screens/my_tickets/tickets_page.dart';
import 'package:task_metro/theme/app_theme.dart';
import 'home_page.dart';

class GNavigation extends StatefulWidget {
  final int selectedIndex;
  final TicketModel? newticket;
  GNavigation({super.key, required this.selectedIndex, required this.newticket});

  @override
  State<StatefulWidget> createState() => _GNavigationState();
}

class _GNavigationState extends State<GNavigation> {
  late int _selectedIndex;

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // backgroundColor: Colors.white,
        title: Text("Exit App", style: Theme.of(context).textTheme.titleLarge),
        content: Text("Are you sure you want to exit the app?", style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Don't exit
            child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit app
            child: Text("Exit", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
    ) ??
        false; // return false if dialog is dismissed
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Widget> _screens = [
      const DashBoardScreen(),
      MyTicketsScreen(newTicket: widget.newticket),
      MapScreen(),
      ProfileMenuScreen(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: _screens[_selectedIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: GNav(
            gap: 8,
            activeColor: colorScheme.primary,
            color: colorScheme.onSurfaceVariant,
            backgroundColor: colorScheme.secondary,
            tabBackgroundColor: colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.confirmation_num, text: 'My Tickets'),
              GButton(icon: Icons.map, text: 'Line Map'),
              GButton(icon: Icons.menu, text: 'Menu'),
            ],
          ),
        ),
      ),
    );
  }
}
