import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('© 2024 My Flutter App, A-Sakagami', textAlign: TextAlign.center),
      ),
    );
  }
}