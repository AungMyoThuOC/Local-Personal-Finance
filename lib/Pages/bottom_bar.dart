import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:personal_finance/Pages/Home/home_page.dart';
import 'package:personal_finance/Pages/Saving/saving_page.dart';
import 'package:personal_finance/Pages/Setting/profile_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(
      id: 1,
    ),
    // const Text("Saving"),
    SavingPage(
      id: 1,
    ),
    const Text("App"),
    ProfilePage(
      id: 1,
    ),
    // const Text("Setting"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xFF526480),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_savings_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_savings_filled),
              label: "Saving"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_apps_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_apps_filled),
              label: "App"),
          BottomNavigationBarItem(
              icon: Icon(FluentSystemIcons.ic_fluent_settings_regular),
              activeIcon: Icon(FluentSystemIcons.ic_fluent_settings_filled),
              label: "Setting"),
        ],
      ),
    );
  }
}
