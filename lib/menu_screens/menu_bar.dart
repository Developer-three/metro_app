import 'package:flutter/material.dart';
import 'package:task_metro/menu_screens/contact_us.dart';
import 'package:task_metro/screens/login_screen.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({Key? key}) : super(key: key);

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  bool darkMode = false;


  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                const Icon(Icons.help_outline,
                    color: Colors.orange, size: 40),
                const SizedBox(height: 16),

                // Text
                const Text(
                  "Are you sure you want to sign out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Yes sign out
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.orange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context)=>LoginScreen())); // close dialog

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Signed out")),
                        );
                      },
                      child: const Text(
                        "Yes, sign out",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),

                    // No go back
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // close dialog
                      },
                      child: const Text(
                        "No, go back",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData.light();
    final darkTheme = ThemeData.dark();

    return Theme(
      data: darkMode ? darkTheme : lightTheme,
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              // Orange header
              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.orange),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Ramesh Kumar",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Info Card
              Positioned(
                top: 160,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border:Border.all(color: Colors.white,width: 2),
                     color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.phone_android, "+91 1234-56789"),
                      _divider(),
                      _buildInfoRow(Icons.email_outlined, "abcde@gmail.com"),
                      _divider(),
                      _buildInfoRow(Icons.lock_outline, "***********",),
                    ],
                  ),
                ),
              ),

              // Menu and Dark Mode
              Padding(
                padding: const EdgeInsets.only(top: 360, left: 18, right: 20),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.history, color: Theme.of(context).iconTheme.color),
                      title: Text("Transaction History", style: Theme.of(context).textTheme.bodyLarge),
                      onTap: () {},
                    ),
                    SwitchListTile(
                      value: darkMode,
                      onChanged: (val) {
                        setState(() {
                          darkMode = val;
                        });
                      },
                      secondary: Icon(Icons.dark_mode, color: Theme.of(context).iconTheme.color),
                      title: Text("Dark Mode", style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_support, color: Theme.of(context).iconTheme.color),
                      title: Text("Contact Us", style: Theme.of(context).textTheme.bodyLarge),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactUsPage()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline, color: Theme.of(context).iconTheme.color),
                      title: Text("Help", style: Theme.of(context).textTheme.bodyLarge),
                      onTap: () {},
                    ),
                    const Spacer(),

                    // Sign out button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.orange,width: 2),
                          minimumSize: const Size(230, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          _showSignOutDialog(context);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sign Out",
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.logout,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              // style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
           Icon(Icons.edit, size: 20),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
