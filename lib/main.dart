import 'package:flutter/material.dart';
import "pages/index.dart";
import "pages/admin.dart";
import "pages/login.dart";
import "pages/about.dart";
import "pages/contact.dart";
import '../storages/storage_service.dart';


void main() async{
  // ストレージを初期化
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: WorkflowToolScreen(),
      home: WorkflowToolScreen(),
      routes: {
        '/about': (context) => AboutPage(),
        '/contact': (context) => ContactPage(),
        '/admin': (context) => AdminPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}