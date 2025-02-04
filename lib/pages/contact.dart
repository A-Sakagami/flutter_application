import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_footer.dart';

class ContactPage extends StatefulWidget{
  const ContactPage({super.key});

  @override
  ContactPageState createState() => ContactPageState();
}

class ContactPageState extends State<ContactPage>{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      endDrawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'お問い合わせ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'こちらのページからお問い合わせいただけます。以下のフォームに必要事項をご記入の上、送信してください。',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('お名前', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _nameController),
              SizedBox(height: 8),
              Text('メールアドレス', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(controller: _emailController, keyboardType: TextInputType.emailAddress),
              SizedBox(height: 8),
              SizedBox(height: 10),
              Text('お問い合わせ内容', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('送信完了'),
                      content: Text('お問い合わせありがとうございます！'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _nameController.clear();
                            _emailController.clear();
                            _messageController.clear();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}