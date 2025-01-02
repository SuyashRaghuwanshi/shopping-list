import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/alternate_chat2.dart';
import 'package:chat_app/screens/settings_screen.dart';
import 'package:chat_app/screens/stream_chat.dart';
import 'package:chat_app/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    final token = await fcm.getToken();

    print(token);
  }

  @override
  void initState() {
    setupPushNotifications();
    super.initState();
  }

  int _selectedIndex = 0;

  final controller = TextEditingController();
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  Future _onAddChat() async {
    final currentUserquery = await firestore
        .collection('users')
        .where('id', isEqualTo: myUserId)
        .get();
    final currentData = currentUserquery.docs[0].data();
    final currentUser = ChatUser(
        name: currentData['username'],
        number: currentData['number'],
        imageUrl: currentData['image_url']);
    final friend = controller.text;

    final friendQuery = await firestore
        .collection('users')
        .where('number', isEqualTo: friend)
        .get();
    if (friendQuery.docs.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User doesn't exist with this number"),
        ),
      );
      return;
    }
    final friendData = friendQuery.docs[0].data();
    final friendUser = ChatUser(
        name: friendData['username'],
        number: friend,
        imageUrl: friendData['image_url']);

    final chatId = firestore.collection('chats').doc().id;
    firestore.collection('chats').doc(chatId).set({
      'chatId': chatId,
      'users': [currentUser.number, friend],
      'usersId': [currentData['id'], friendData['id']],
      'usernames': [currentUser.name, friendUser.name],
      'userImages': [currentUser.imageUrl, friendUser.imageUrl]
    });
    controller.clear();
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add to chats',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          content: TextField(
            controller: controller,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter your friend's Number",
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _onAddChat(); // Close the dialog
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _onChange(int val) async {
    setState(() {
      _selectedIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? ' Chats' : 'Settings',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 27, color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      bottomNavigationBar: BottomNavigator(_onChange),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                _showAlertDialog(context);
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: _selectedIndex == 0 ? const StreamChat() : const SettingsScreen(),
    );
  }
}
