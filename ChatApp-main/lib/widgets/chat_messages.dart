import 'package:chat_app/models/chat.dart';
import 'package:chat_app/widgets/image_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages(this.chat, {super.key});

  final Chat chat;
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
                _deleteMessage(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage(String id) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chat.chatId)
        .collection('messages')
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chat.chatId)
            .collection('messages')
            .orderBy('sentAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No messages to show',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            );
          }

          if (chatSnapshots.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 90, left: 13, right: 13),
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, idx) {
                final currentUser = FirebaseAuth.instance.currentUser!.uid;
                final sender = loadedMessages[idx].data()['userId'];
                return InkWell(
                  onLongPress: () {
                    _showAlertDialog(context, loadedMessages[idx].id);
                  },
                  child: Align(
                    alignment: sender == currentUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: loadedMessages[idx].data()['text'] != null
                        ? Card(
                            color: sender == currentUser
                                ? Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer
                                : Theme.of(context).colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 13),
                              child: Text(
                                loadedMessages[idx].data()['text'],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                              ),
                            ))
                        : InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ImageView(
                                      image: loadedMessages[idx]
                                          .data()['image'])));
                            },
                            child: Image.network(
                              loadedMessages[idx].data()['image'],
                              width: 200,
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                );
              });
        });
  }
}
