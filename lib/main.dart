import 'package:flutter/material.dart';
import "pages/index.dart";
import "pages/admin.dart";
import "pages/login.dart";
import "pages/about.dart";
import "pages/contact.dart";


void main() {
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