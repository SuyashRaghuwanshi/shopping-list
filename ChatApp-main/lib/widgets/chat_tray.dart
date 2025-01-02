import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatTray extends StatelessWidget {
  const ChatTray(this.chat, this.friend, {super.key});

  final Chat chat;
  final ChatUser friend;

  void _showAlertDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteChat(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteChat(String id) {
    FirebaseFirestore.instance.collection('chats').doc(chat.chatId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatScreenInd(chat: chat, friend: friend)));
      },
      onLongPress: () {
        _showAlertDialog(context, chat.chatId);
      },
      child: SizedBox(
        width: 400,
        child: Container(
          decoration: BoxDecoration(
              border: Border.symmetric(
                  vertical: BorderSide(color: Colors.white.withOpacity(0.1))),
              borderRadius: BorderRadius.circular(20)),
          child: Card(
            color: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.transparent
                : null,
            borderOnForeground: false,
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  if (friend.imageUrl != 'imageUrl')
                    CircleAvatar(
                      backgroundImage: NetworkImage(friend.imageUrl),
                    ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    friend.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 23),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
