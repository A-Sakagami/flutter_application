import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_drawer.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomHeader(),
      endDrawer: const CustomDrawer(),
      body: Center(
        child: Text('Welcome to the Admin Page!'),
      ),
    );
  }
}