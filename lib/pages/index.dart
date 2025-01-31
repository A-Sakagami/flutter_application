import 'package:flutter/material.dart';
import '../storages/storage_service.dart';
import '../storages/user_data.dart';
import '../storages/text_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_footer.dart';

class WorkflowToolScreen extends StatefulWidget {
  const WorkflowToolScreen({super.key});

  @override
  WorkflowToolScreenState createState() => WorkflowToolScreenState();
}

class WorkflowToolScreenState extends State<WorkflowToolScreen> {
  UserData? _currentUser;
  List<TextData> _texts = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserAndData();
  }

  Future<void> _loadUserAndData() async {
    final user = await StorageService.getCurrentUser();
    final textList = await StorageService.getAllTexts();
    setState(() {
      _currentUser = user;
      _texts = textList;
    });
  }

  Future<void> _submitText() async {
    if (_textController.text.isNotEmpty) {
      await StorageService.saveText(TextData(
        text: _textController.text,
        approved: false,
        denyed: false,
      ));
      _textController.clear();
      await _loadUserAndData(); // リストを更新
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      endDrawer: const CustomDrawer(),
      body: _currentUser == null ? _buildGuestView() : _buildUserView(),
      bottomNavigationBar: const CustomFooter(),
    );
  }


  Widget _buildGuestView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'ワークフローツール',
            style: const TextStyle(fontSize: 24, fontWeight:FontWeight.bold),
          ),
          const SizedBox(height: 20), 
          const Text(
            'ログインしてください。',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20), // テキストとボタンの間にスペースを追加
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // ボタンの背景色を青色に設定
              shadowColor: Colors.blueAccent,
            ),
            child: const Text('ログイン', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

  Widget _buildUserView() {
    if (_currentUser!.username != "user") return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ワークフローツール',
              style: const TextStyle(
                fontSize: 24, 
                fontWeight:FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '下のテキストエリアに文字を入力して、送信してください。',
              ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'テキストを入力',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: _submitText,
              child: const Text('送信'),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(child: _buildTextList()),
        ],
      ),
    );
  }

  Widget _buildTextList() {
    return ListView.builder(
      itemCount: _texts.length,
      itemBuilder: (context, index) {
        final text = _texts[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              text.text ?? '',
            ),
            tileColor: text.approved ?? true ? Colors.lightGreen
             : (text.denyed?? true ? Colors.redAccent : Colors.lightBlue), 
          ),
        );
      },
    );
  }
}
