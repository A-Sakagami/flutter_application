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

      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18), // bodyのテキスト（大）
          bodyMedium: TextStyle(fontSize: 16), // bodyのテキスト（中）
          bodySmall: TextStyle(fontSize: 14), // bodyのテキスト（小）
          headlineLarge: TextStyle(fontSize: 32), // 見出し（大） 
          headlineMedium: TextStyle(fontSize: 24), // 見出し（大） 
          headlineSmall: TextStyle(fontSize: 16), // 見出し（大） 
        ),
      ),
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