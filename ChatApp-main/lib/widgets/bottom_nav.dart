import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavigator extends StatelessWidget {
  const BottomNavigator(this.onClick, {super.key});

  final void Function(int val) onClick;

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
            selectedIndex: selectedIndex,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            gap: 10,
            onTabChange: (value) {
              if (value == 0) {
                selectedIndex = 0;
                onClick(value);
              } else {
                selectedIndex = 1;
                onClick(value);
              }
            },
            activeColor: Colors.white,
            tabs: const [
              GButton(
                backgroundColor: Color.fromARGB(255, 56, 56, 56),
                icon: Icons.home,
                text: 'Home',
                haptic: true,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(8),
              ),
              GButton(
                backgroundColor: Color.fromARGB(255, 56, 56, 56),
                icon: Icons.settings,
                text: 'Settings',
                haptic: true,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(8),
              )
            ]),
      ),
    );
  }
}
