import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isMessageFilled = false;

  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      setState(() {
        isMessageFilled = messageController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          "Contact Us",
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // Subject field
            TextField(
              controller: subjectController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Subject",
                hintText: "Enter Subject",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                labelStyle: TextStyle(color: textColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Message field
            TextField(
              controller: messageController,
              maxLines: 6,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Message",
                hintText: "Enter your Message",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                labelStyle: TextStyle(color: textColor),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 80),

            // Send Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isMessageFilled
                      ? primaryColor
                      : theme.disabledColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: isMessageFilled
                    ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message Sent")),
                  );
                  setState(() {
                    messageController.clear();
                  });
                }
                    : null,
                child: const Text(
                  "Send",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
