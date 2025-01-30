import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';

class WorkflowToolScreen extends StatefulWidget {
  const WorkflowToolScreen({super.key});

  @override
  WorkflowToolScreenState createState() => WorkflowToolScreenState();
}

class WorkflowToolScreenState extends State<WorkflowToolScreen> {
  bool isLoggedIn = false;
  final TextEditingController _postController = TextEditingController();


  /// Aboutページへ遷移
  void toggleAbout() {
    Navigator.pushNamed(context, '/about');
  }

  /// Contactページへ遷移
  void toggleContact() {
    Navigator.pushNamed(context, '/contact');
  }

  /// ログインページへ遷移
  void toggleLogin() {
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white30),
              child: Text('メニュー', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: Text('Home')),
            ListTile(
              title: Text('About'),
              onTap: toggleAbout,
            ),
            ListTile(
              title: Text('Contact'),
              onTap: toggleContact,
            ),
            ListTile(
              title: Text('Login'),
              onTap: toggleLogin,
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
                onPressed: toggleLogin,
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