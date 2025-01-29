import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WorkflowToolScreen(),
    );
  }
}

class WorkflowToolScreen extends StatefulWidget {
  const WorkflowToolScreen({super.key});

  @override
  WorkflowToolScreenState createState() => WorkflowToolScreenState();
}

class WorkflowToolScreenState extends State<WorkflowToolScreen> {
  bool isLoggedIn = false;
  final TextEditingController _postController = TextEditingController();

  void _toggleLogin() {
    setState(() {
      isLoggedIn = !isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workflow Tool'),
        actions: [
          if (!isLoggedIn)
            TextButton(
              onPressed: _toggleLogin,
              child: Text('Login', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('メニュー', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: Text('Home')),
            ListTile(title: Text('About')),
            ListTile(title: Text('Contact')),
            ListTile(
              title: Text('Login'),
              onTap: _toggleLogin,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ワークフローツール', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('ようこそ！このアプリはFlutterで作られています。'),
            SizedBox(height: 8),
            Column(
              children: [
                Text('• 高速で軽量'),
                Text('• シンプルな構成'),
                Text('• 柔軟なカスタマイズ'),
              ],
            ),
            SizedBox(height: 16),
            if (!isLoggedIn)
              ElevatedButton(
                onPressed: _toggleLogin,
                child: Text('ログイン'),
              ),
            if (isLoggedIn) ...[
              Text('下のテキストエリアに文字を入力して、送信してください。'),
              TextField(controller: _postController, decoration: InputDecoration(hintText: 'ここに入力してください...')),
              SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: Text('送信')),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('© 2024 My Flutter App', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
