import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:personal_assistant_app/appointments%20page/appointments_page.dart';
import 'package:personal_assistant_app/assets%20page/assets_page.dart';
import 'package:personal_assistant_app/settings%20page/settings_page.dart';
import 'package:personal_assistant_app/settings%20page/theme_notifier.dart';
import 'package:personal_assistant_app/tasks%20page/tasks_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected tab

  // Pages for the navigation bar
  final List<Widget> _pages = [
    const TasksPage(), // Page 1: To-Do List
    const AssetsPage(), // Page 2: Calendar/Events
    const AppointmentsPage(), // Page 3: Appointments
    const SettingsPage(), // Page 4: Settings
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final backgroundColor = Theme.of(context).bottomAppBarColor;
    final iconColor = Theme.of(context).iconTheme.color;
    final activeColor =
        themeNotifier.isDarkMode ? Colors.blueAccent : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false, // Remove the back button
        title: const Text(
          'PA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: _pages[_selectedIndex], // Show the page based on selected index
      bottomNavigationBar: Container(
        color: backgroundColor,
        child: GNav(
          gap: 8, // The gap between icons
          activeColor: activeColor, // The active color of the icons
          iconSize: 24, // The size of the icons
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 500),
          tabBackgroundColor:
              activeColor.withOpacity(0.1), // Background color for active tab
          color: iconColor, // Default color for icons
          selectedIndex: _selectedIndex, // Current tab index
          onTabChange: _onItemTapped, // Tab change handler
          tabs: const [
            GButton(
              icon: Icons.list,
              text: 'Tasks',
            ),
            GButton(
              icon: Icons.house_rounded,
              text: 'Assets',
            ),
            GButton(
              icon: Icons.event,
              text: 'Appointments',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
