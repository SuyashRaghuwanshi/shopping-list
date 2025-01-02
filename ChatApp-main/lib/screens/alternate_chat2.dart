// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firestore = FirebaseFirestore.instance;

class AlternateChat2 extends StatefulWidget {
  const AlternateChat2({super.key});

  @override
  State<AlternateChat2> createState() {
    return _AlternateChat2State();
  }
}

class _AlternateChat2State extends State<AlternateChat2> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Chats',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontSize: 25, color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlertDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: const Text('None'),
    );
  }
}
