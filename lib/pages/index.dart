import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_footer.dart';

class WorkflowToolScreen extends StatefulWidget {
  const WorkflowToolScreen({super.key});

  @override
  WorkflowToolScreenState createState() => WorkflowToolScreenState();
}

class WorkflowToolScreenState extends State<WorkflowToolScreen> {
  bool isLoggedIn = false;
  bool isAdmin = false;
  final TextEditingController _postController = TextEditingController();

  /// ホーム画面制御
  void toggleHome() {
    if (!isLoggedIn) {
      Navigator.pushNamed(context, '/');
    } else if (isAdmin) {
      Navigator.pushNamed(context, '/admin');
    } else {
      Navigator.pushNamed(context, '/index');
    }
  }

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
      endDrawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ワークフローツール', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('ようこそ！このアプリはFlutterで作られています。'),
            SizedBox(height: 8),
            Align(
              /// 左揃え
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• 高速で軽量'),
                  Text('• シンプルな構成'),
                  Text('• 柔軟なカスタマイズ'),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (!isLoggedIn)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
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
      bottomNavigationBar: const CustomFooter(),
    );
  }

  
}