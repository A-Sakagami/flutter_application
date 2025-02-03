import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  const CustomHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          ModalRoute.of(context)?.settings.arguments as String? ?? "Workflow Tool",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      shadowColor: Colors.white12,
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 40),
            onPressed: () {
              final scaffoldState = Scaffold.maybeOf(context);
              if (scaffoldState != null && scaffoldState.hasEndDrawer) {
                scaffoldState.openEndDrawer();
              } else {
                debugPrint("Scaffold の endDrawer が見つかりませんでした");
              }
            },
          ),
        ),
      ],
    );
  }
}
