import 'package:flutter/material.dart';
import 'package:task_metro/menu_screens/contact_us.dart';
import 'package:task_metro/menu_screens/transaction_history.dart';
import 'package:task_metro/screens/login_screen.dart';
import 'package:task_metro/theme/app_theme.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({Key? key}) : super(key: key);

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  bool darkMode = false;

  void _showSignOutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: AppTheme.lightTheme,

          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.help_outline, color: Theme.of(context).colorScheme.primary, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    "Are you sure you want to sign out?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Signed out")),
                          );
                        },
                        child: Text("Yes, sign out", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text("No, go back", style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Theme(
      data: darkMode ? ThemeData.dark() : ThemeData.light(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              // Orange header
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: colorScheme.onPrimary,
                      child: Icon(Icons.person, size: 50, color: colorScheme.primary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Ramesh Kumar",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
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
                    border: Border.all(color: colorScheme.onPrimary, width: 2),
                    color: theme.cardColor,
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
                      _divider(context),
                      _buildInfoRow(Icons.email_outlined, "abcde@gmail.com"),
                      _divider(context),
                      _buildInfoRow(Icons.lock_outline, "***********"),
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
                      leading: Icon(Icons.history, color: theme.iconTheme.color),
                      title: Text("Transaction History", style: theme.textTheme.bodyLarge),
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>TransactionHistoryScreen()));
                      },
                    ),
                    SwitchListTile(
                      value: darkMode,
                      onChanged: (val) => setState(() => darkMode = val),
                      secondary: Icon(Icons.dark_mode, color: theme.iconTheme.color),
                      title: Text("Dark Mode", style: theme.textTheme.bodyLarge),
                    ),
                    ListTile(
                      leading: Icon(Icons.contact_support, color: theme.iconTheme.color),
                      title: Text("Contact Us", style: theme.textTheme.bodyLarge),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ContactUsPage()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.help_outline, color: theme.iconTheme.color),
                      title: Text("Help", style: theme.textTheme.bodyLarge),
                      onTap: () {},
                    ),
                    const Spacer(),

                    // Sign Out Button
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.primary, width: 2),
                          minimumSize: const Size(230, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () => _showSignOutDialog(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sign Out",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.iconTheme.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.logout, color: theme.iconTheme.color),
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: theme.iconTheme.color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          Icon(Icons.edit, size: 20, color: theme.iconTheme.color),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
