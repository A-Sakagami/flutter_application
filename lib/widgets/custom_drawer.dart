import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.black45),
            child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () => Navigator.pushNamed(context, '/'),
          ),
          ListTile(
            title: const Text('About'),
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          ListTile(
            title: const Text('Contact'),
            onTap: () => Navigator.pushNamed(context, '/contact'),
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () => Navigator.pushNamed(context, '/login'),
          ),
        ],
      ),
    );
  }
}
