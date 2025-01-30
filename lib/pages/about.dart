import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget implements PreferredSizeWidget{
    final String title = 'About';
    final String description = 'このサイトについて\nこのサイトは、エンドツーエンドのテストをサポートするために作成されました。';
    const AboutPage({super.key});

    @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(title),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                    children: [
                        Text(description),
                    ],
                ),
            ),
        );
    }
}