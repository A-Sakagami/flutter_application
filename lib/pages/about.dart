import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ヘッダー部分にハンバーガーメニューを出す
      appBar: const CustomHeader(),
      /// すべてのページで CustomHeader を使う場合、必ず Scaffold に endDrawer を設定する必要がある
      /// 共通コンポーネントにした
      endDrawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              'このアプリについて',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'このアプリケーションは、エンドツーエンドのテストをサポートするために作成されました。',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
