import 'package:flutter/material.dart';
import 'package:go_desi/screens/friendscreen.dart';
import 'package:go_desi/screens/groupscreen.dart';
import 'package:go_desi/screens/homescreen.dart';
import 'package:go_desi/screens/settingscreen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(
    MaterialApp(
      home: MainScreen(),
    )
  );
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    GroupScreen(),
    FriendsScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: screens[_selectedIndex],
      bottomNavigationBar: GNav(
          tabMargin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.white,
          haptic: true,
          selectedIndex: 0,
          onTabChange: (index) => {
            setState(() {
              _selectedIndex = index;
            })
          },
          tabs: [
            GButton(
              icon: Icons.home,
              gap: 10,
              text: 'Home',
            ),
            GButton(
              icon: Icons.group,
              gap: 10,
              text: 'Group',
            ),
            GButton(
              icon: Icons.person,
              gap: 10,
              text: 'Friends',
            ),
            GButton(
              icon: Icons.settings,
              gap: 10,
              text: 'Settings',
            )
          ]
      ),
      floatingActionButton: Visibility(
        visible: _selectedIndex != 3,
        child: FloatingActionButton.extended(
          
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          focusColor: Colors.black,
        
          onPressed: () {
        
          },
          label: const Text('Add an expense'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}



