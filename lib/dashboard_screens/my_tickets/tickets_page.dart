import 'package:flutter/material.dart';
import 'package:task_metro/dashboard_screens/bottom_navigation.dart';
import 'package:task_metro/dashboard_screens/home_page.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildEmptyTicketMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 60, color: Colors.grey.shade500),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Need tickets?",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>GNavigation(selectedIndex: 0)),(route)=>false);
              },
              icon: const Icon(Icons.add),
              label: const Text("Buy QR Tickets"),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          'My Tickets',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
             borderRadius: BorderRadius.circular(50),

            color: Colors.white,
          ),
          labelColor: Colors.black87,
          unselectedLabelColor: Colors.white,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
          unselectedLabelStyle:const TextStyle(fontWeight: FontWeight.normal),
          // const TextStyle(fontWeight: FontWeight.normal,fontSize: 12),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 1,vertical: 5),
          tabs: const [
            SizedBox(
              width: 180,
            child: Tab(text: "Available Tickets"),
            ),
            SizedBox(
              width: 160,
            child: Tab(text: "Used Tickets"),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEmptyTicketMessage("You have no available tickets at the moment."),
          _buildEmptyTicketMessage("You have no used tickets at the moment."),
        ],
      ),
    );
  }
}
