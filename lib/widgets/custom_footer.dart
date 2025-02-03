import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color.fromRGBO(51, 51, 51, 1),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          '© 2024 My Flutter App',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}