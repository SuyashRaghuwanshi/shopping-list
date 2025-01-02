import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreenInd extends StatefulWidget {
  const ChatScreenInd({super.key, required this.chat, required this.friend});

  final Chat chat;
  final ChatUser friend;

  @override
  State<ChatScreenInd> createState() {
    return _ChatScreenIndState();
  }
}

class _ChatScreenIndState extends State<ChatScreenInd> {
  void _clearChat() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chat.chatId)
        .collection('messages')
        .get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Clear',
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
                _clearChat();
                Navigator.of(context).pop();
              },
              child: const Text('Clear'),
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
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.friend.imageUrl),
            ),
            const SizedBox(width: 10),
            Text(
              widget.friend.name,
              softWrap: true,
            ),
          ],
        ),
        actions: [
          MenuBar(
              style: const MenuStyle(
                  shadowColor: MaterialStatePropertyAll(Colors.transparent),
                  surfaceTintColor:
                      MaterialStatePropertyAll(Colors.transparent)),
              children: [
                SubmenuButton(
                    menuChildren: [
                      MenuItemButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) =>
                                  ProfileView(widget.friend, false)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Profile',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ),
                      ),
                      MenuItemButton(
                        onPressed: () {
                          _showAlertDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Clear chat',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                        ),
                      ),
                    ],
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onBackground,
                    ))
              ])
        ],
      ),
      body: Column(
        children: [Expanded(child: ChatMessages(widget.chat))],
      ),
      bottomSheet: NewMessage(
        chat: widget.chat,
      ),
    );
  }
}
