import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatefulWidget{
  const ContactUsPage({Key?key}):super(key: key);

  @override
  State<ContactUsPage> createState()=>_ContactUsPageState();

}
class _ContactUsPageState extends State<ContactUsPage>{

  final TextEditingController subjectController=TextEditingController();
  final TextEditingController messageController=TextEditingController();

  bool isMessageFilled=false;

  @override
  void initState(){
    super.initState();
    messageController.addListener((){
      setState(() {
        isMessageFilled=messageController.text.isNotEmpty;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.orange,
      elevation: 0,
      title:Text("Contact Us",style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white),onPressed: (){
        Navigator.pop(context);
      },
      ),
    ),
    body: Padding(padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        TextField(
          controller: subjectController,
          decoration: InputDecoration(
            labelText: "Subject",
            hintText: "Enter Subject",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            BorderSide(color: Colors.orange, width: 2),
          ),
        ),
        ),
        SizedBox(height: 36),
        TextField(
          controller: messageController,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: "Message",
            hintText: "Enter your Message",
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                BorderSide(color: Colors.orange, width: 2),
              ),
              border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            )
          ),
        ),
          SizedBox(height: 100),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isMessageFilled?Colors.orange:Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          onPressed: isMessageFilled?(){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Message Sent")));
              setState(() {
                messageController.clear();
              });
          }:null, child: Text("Send",style: TextStyle(fontSize: 18,color:Colors.white),)),
        )
      ],
    ),

    ),
      );
  }

}