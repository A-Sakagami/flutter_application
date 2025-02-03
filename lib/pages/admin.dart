import 'package:flutter/material.dart';
import '../storages/storage_service.dart';
import '../storages/user_data.dart';
import '../storages/text_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_footer.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  
  // UserDataのフィールド
  String? username;
  String? password;
  bool isAdmin = false;
  bool isLoggedIn = false;
  
  // TextDataのフィールド
  String? text;
  int? id;
  bool approved = false;
  bool denyed = false;

  // 保存済みのデータ
  List<UserData> users = [];
  List<TextData> texts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedUsers = await StorageService.getAllUsers();
    final loadedTexts = await StorageService.getAllTexts();
    setState(() {
      users = loadedUsers;
      texts = loadedTexts;
    });
  }

  Future<void> _saveUserData() async {
    if (username != null && password != null) {
      final userData = UserData(
        username: username,
        password: password,
        isAdmin: isAdmin,
        isLoggedIn: isLoggedIn,
      );
      await StorageService.saveUser(userData);
      await _loadData(); // リストを更新
    }
  }

  // Future<void> _saveTextData() async {
  //   if (text != null) {
  //     final textData = TextData(
  //       text: text,
  //       approved: approved,
  //       denyed: denyed,
  //       id: id,
  //     );
  //     await StorageService.saveText(textData);
  //     await _loadData(); // リストを更新
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      endDrawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('管理者専用ページ', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),

              SizedBox(height: 16),

              Text('投稿された文字列', style: Theme.of(context).textTheme.titleLarge),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: texts.length,
                itemBuilder: (context, index) {
                  final textData = texts[index];
                  return ListTile(
                    title: Text(textData.text?.isNotEmpty == true ? textData.text! : '投稿がありません'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${textData.id}'),
                        ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () async {
                          if (textData.safeDenyed) {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('承認と否認を同時に設定することはできません。')),
                            );
                            return;
                          }
                          setState(() {
                            textData.approved = !textData.safeApproved;
                          });
                          await StorageService.saveText(textData);
                          await _loadData();
                          },
                          child: Text(textData.safeApproved ? '承認取り消し' : '承認'),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(),
                          onPressed: () async {
                          if (textData.safeApproved) {
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('承認と否認を同時に設定することはできません。')),
                            );
                            return;
                          }
                          setState(() {
                            textData.denyed = !textData.safeDenyed;
                          });
                          await StorageService.saveText(textData);
                          await _loadData();
                          },
                          child: Text(textData.safeDenyed ? '否認取り消し' : '否認'),
                        ),
                      ],
                    ),
                    /// ゴミ箱ボタン
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                      await StorageService.deleteTextById(index);
                      await _loadData();
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 20),
              
              Text('ユーザー登録', style: Theme.of(context).textTheme.titleLarge),
              TextFormField(
                decoration: InputDecoration(labelText: 'user name'),
                onChanged: (value) => setState(() => username = value),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'password'),
                obscureText: true,
                onChanged: (value) => setState(() => password = value),
              ),
              CheckboxListTile(
                title: Text('管理者権限'),
                value: isAdmin,
                onChanged: (value) => setState(() => isAdmin = value ?? false),
              ),
              CheckboxListTile(
                title: Text('ログイン情報'),
                value: isLoggedIn,
                onChanged: (value) => setState(() => isLoggedIn = value ?? false),
              ),
              ElevatedButton(
                onPressed: _saveUserData,
                child: Text('保存する'),
              ),

              SizedBox(height: 20),
            
            Text('保存済みのユーザー一覧:', style: Theme.of(context).textTheme.titleLarge),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.username ?? 'No name'),
                    subtitle: Text('Admin: ${user.isAdmin}, Logged In: ${user.isLoggedIn}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await StorageService.deleteUser(index);
                        await _loadData();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}