import 'package:flutter/material.dart';
import '../storages/storage_service.dart';
import '../storages/user_data.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer>  {
  UserData? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await StorageService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _logout() async {
    // Implement your logout logic here
    await StorageService.logout();
    setState(() {
      _currentUser = null;
    });
    Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
  }

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
            onTap: () {
              final bool isAdmin = _currentUser?.isAdmin ?? false;
              Navigator.pushNamed(context, isAdmin ? '/admin' : '/');
            },
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
            title: Text(_currentUser?.isLoggedIn ?? false ? 'Logout' : 'Login'),
            onTap: () {
              final bool isLoggedIn = _currentUser?.isLoggedIn ?? false;
              if (isLoggedIn) {
                _logout();
              } 
              Navigator.pushNamed(context, '/login');
            }
          ),
        ],
      ),
    );
  }
}
