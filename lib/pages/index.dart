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
      // 新しいIDを生成（既存の最大IDに1を加える）
      final newId = (_texts.isNotEmpty ? _texts.map((e) => e.id!).reduce((before, edit) => before > edit ? before : edit) : 0) + 1;
      await StorageService.saveText(TextData(
        text: _textController.text,
        approved: false,
        denyed: false,
        id: newId, // 新しいIDを設定
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
              // 否認された場合、テキストで再投稿を促す
                text.safeDenyed ? '否認されました。再投稿してください。\n${text.text}' : text.text ?? '',
            ),
            textColor: text.safeApproved ? Colors.black : Colors.white,
            tileColor: text.safeApproved ? Colors.green
             : (text.safeDenyed ? Colors.redAccent : Colors.lightBlue), 
             // 否認済みならタップで編集
            onTap: text.safeDenyed ? () => _editDeniedText(context, text) : null, 
          ),
        );
      },
    );
  }
  void _editDeniedText(BuildContext context, TextData textData) {
    TextEditingController editController =
        TextEditingController(text: textData.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('再編集'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              labelText: '修正するテキストを入力',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedText = editController.text.trim();
                if (updatedText.isNotEmpty) {
                  // 既存データを更新（id 付きのデータを保存）
                  final updatedTextData = TextData(
                    id: textData.id, // 必ず元のIDを維持
                    text: updatedText,
                    approved: false, // 再投稿時は未承認状態に戻す
                    denyed: false, // 否認状態を解除
                  );

                  await StorageService.updateText(updatedTextData); // 更新処理を呼び出す
                  await _loadUserAndData(); // 更新後のデータをロード
                  Navigator.pop(context); // ダイアログを閉じる
                }
              },
              child: const Text('再投稿'),
            ),
          ],
        );
      },
    );
  }
}
