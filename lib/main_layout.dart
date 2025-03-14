import 'package:flutter/material.dart';
import 'package:tiket_wisata/screens/home_screen.dart';
import 'package:tiket_wisata/screens/profile_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:tiket_wisata/components/button_mainlayout.dart';
import 'package:tiket_wisata/screens/semuadoa_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
     HomeScreen(),
     ProfileScreen(),
     SemuadoaScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff6200ee),
        unselectedItemColor: const Color(0xff757575),
        onTap: _onItemTapped,
        items: [
          buttonMainlayout(icon:  Icon(Icons.home), teks: 'Home', color: Colors.green),
          buttonMainlayout(icon:  Icon(Icons.person), teks: 'Profile', color: Colors.green),
          buttonMainlayout(icon:  Icon(Icons.book), teks: 'Doa', color: Colors.green),
        ],
      ),
    );
  }
}
