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

class AdminPageState extends State<AdminPage> with SingleTickerProviderStateMixin {
  //final _formKey = GlobalKey<FormState>();
  List<UserData> users = [];
  List<TextData> texts = [];

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

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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

  Widget _buildUserList() {
    return SingleChildScrollView( // ここでスクロールをラップ
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true, // 高さを調整
            physics: NeverScrollableScrollPhysics(), // 内部スクロールを防ぐ
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
    );
  }

  Widget _buildUserRegistrationForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ユーザー登録',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'User Name'),
            onChanged: (value) => setState(() => username = value),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
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
        ],
      ),
    );
  }

  Widget _buildUserUpdate() {return Expanded(child: SizedBox(height: 20));}
  Widget _buildUserDelete() {return Expanded(child: SizedBox(height: 20));}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const CustomHeader(),
        endDrawer: const CustomDrawer(),
        body: Column(
          children: [
            Container(
              color: Color.fromARGB(200, 223, 223, 255),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '管理者専用ページ',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(200, 136, 203, 127),
                                    foregroundColor: Colors.white,
                                  ),
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
                                SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(200, 244, 67, 54),
                                    foregroundColor: Colors.white,
                                  ),
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
                          ],
                        ),
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
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(child: Text("ユーザー一覧", style: TextStyle(fontSize: 16))),
                Tab(child: Text("ユーザー登録", style: TextStyle(fontSize: 16))),
                Tab(child: Text("ユーザー情報更新", style: TextStyle(fontSize: 16))),
                Tab(child: Text("ユーザー削除", style: TextStyle(fontSize: 16))),
              ],
            ),
            Expanded( // Container ではなく Expanded に変更
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildUserList(),
                  _buildUserRegistrationForm(),
                  _buildUserUpdate(),
                  _buildUserDelete(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomFooter(),
      ),
    );
  }
}