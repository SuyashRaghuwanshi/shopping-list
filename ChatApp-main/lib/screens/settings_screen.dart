import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => Profile()));
            },
            title: Text(
              'Profile',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.adb_outlined),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const AppDrawer()));
            },
            title: Text(
              'About',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          )
        ],
      ),
    );
  }
}
