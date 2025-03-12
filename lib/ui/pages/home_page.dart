import 'package:flutter/material.dart';
import 'package:offline_courier_app/core/services/auth_service.dart';
import 'package:offline_courier_app/core/utils/appbar.dart';
import 'package:offline_courier_app/ui/pages/login_page.dart';
import 'package:offline_courier_app/ui/pages/map_page.dart';
import 'package:offline_courier_app/ui/pages/ordersPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Sayfalar listesi
  final List<Widget> _pages = [MapPage(), OrdersPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await AuthService().logoutUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: _selectedIndex == 0 ? 'Harita' : 'Siparişlerim',
        icon: Icons.logout,
        onIconPressed: _logout,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Harita'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Siparişlerim',
          ),
        ],
      ),
    );
  }
}
