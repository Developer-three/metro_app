import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:task_metro/dashboard_screens/map_city.dart';
import 'package:task_metro/menu_screens/menu_bar.dart';
import 'package:task_metro/dashboard_screens/my_tickets/tickets_page.dart';

import 'home_page.dart';

class GNavigation extends StatefulWidget {
  final int selectedIndex;
  GNavigation({super.key, required this.selectedIndex});

  @override
  State<StatefulWidget> createState() => _GNavigationState();
}

class _GNavigationState extends State<GNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashBoardScreen(),
    const MyTicketsScreen(), // Create this screen or import
    MapScreen(),
    ProfileMenuScreen(),

  ];
  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit the app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Don't exit
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Exit app
            child: const Text("Exit"),
          ),
        ],
      ),
    ) ?? false; // return false if dialog is dismissed
  }


  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _screens[_selectedIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: GNav(
            gap: 8,
            activeColor: Colors.orange,
            color: Colors.grey[700],
            backgroundColor: Colors.white,
            tabBackgroundColor: Colors.orange.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
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
