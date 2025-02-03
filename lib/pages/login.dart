import 'package:flutter/material.dart';
import 'package:flutter_application/storages/storage_service.dart';
// セッション管理ライブラリhive
import 'package:hive_flutter/hive_flutter.dart';
import '../storages/user_data.dart';
// プリセットウィジェット
import '../widgets/custom_header.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_footer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

/// 
/// private: クラス名の先頭に"_"をつける
/// public にしたくないなら、それを使うクラスやメソッドも全て private にする
/// getter, setterのみpublicで扱う
///
class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  
  // UserDataのフィールド
  String? name;
  String? password;
  bool isAdmin = false;
  bool isLoggedIn = false;

  // 保存済みのデータ
  List<UserData> users = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPageState();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedUsers = await StorageService.getAllUsers();
    setState(() {
      users = loadedUsers;
    });
  }

  /// ログイン情報をストレージに保存する
  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (!mounted) return;

    var userBox = await Hive.openBox<UserData>('userBox');
    UserData userData;

    if (username == "admin" && password == "adminpass1234") {
      userData = UserData()
        ..username = username
        ..password = password
        ..isLoggedIn = true
        ..isAdmin = true;
      await userBox.put('userData', userData);
      await _loadData(); // リストを更新
      if (mounted) Navigator.pushReplacementNamed(context, '/admin');
    } 
    else if (username == "user" && password == "userpass1234") {
      userData = UserData()
        ..username = username
        ..password = password
        ..isLoggedIn = true
        ..isAdmin = false;
      await userBox.put('userData', userData);
      await _loadData(); // リストを更新
      if (mounted) Navigator.pushReplacementNamed(context, '/');
    }
    else if (username.isNotEmpty && password.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ログイン情報が正しくありません')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      endDrawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'ユーザー名',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'メールアドレスを入力してください。';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'パスワード',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'パスワードを入力してください。';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                     _login();
                  }
                },
                child: Text('ログイン'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}