import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/chat_tray.dart';
import 'package:chat_app/widgets/drawer.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlternateChatScreen extends StatefulWidget {
  const AlternateChatScreen({super.key});

  @override
  State<AlternateChatScreen> createState() {
    return _AlternateChatScreenState();
  }
}

class _AlternateChatScreenState extends State<AlternateChatScreen> {
  final controller = TextEditingController();
  String currentUser = '';
  ChatUser? myUser;

  @override
  void initState() {
    _getCurrentUser();
    _populateChats();
    super.initState();
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
                _onAddChat(); // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future _onAddChat() async {
    final friend = controller.text;
    final chatId = firestore.collection('chats').doc().id;
    setState(() {
      firestore.collection('chats').doc(chatId).set({
        'chatId': chatId,
        'user1': currentUser,
        'user2': friend,
      });
    });
  }

  Future _getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    final query = await firestore
        .collection('users')
        .where('id', isEqualTo: userId)
        .get();
    currentUser = query.docs[0]['number'];
    final docs = query.docs[0].data();
    myUser = ChatUser(
      name: docs['username'],
      number: currentUser,
      imageUrl: docs['image_url'],
    );
  }

  Future getUserByNum(String number, ChatUser user) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('number', isEqualTo: number)
        .get();
    if (query.docs.isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User doesn't exist with this number"),
        ),
      );
      return;
    }

    final data = query.docs[0].data();
    user.imageUrl = data['image_url'];
    user.number = data['number'];
    user.name = data['username'];
  }

  List<Chat> chats = [];

  void _populateChats() async {
    //getting current user
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    final query = await firestore
        .collection('users')
        .where('id', isEqualTo: userId)
        .get();
    final data = query.docs[0].data();
    currentUser = query.docs[0]['number'];
    final myUser = ChatUser(
        name: data['username'],
        number: currentUser,
        imageUrl: data['image_url']);
    //gettting corresponding chats
    final query1 = await firestore
        .collection('chats')
        .where('user1', isEqualTo: currentUser)
        .get();
    final query2 = await firestore
        .collection('chats')
        .where('user2', isEqualTo: currentUser)
        .get();

    //filling the chatsList
    for (final chat in query1.docs) {
      final friendNum = chat['user2'];
      final friendQuery = await firestore
          .collection('users')
          .where('number', isEqualTo: friendNum)
          .get();
      final friendDoc = friendQuery.docs[0].data();
      ChatUser user2 = ChatUser(
          name: friendDoc['username'],
          number: friendNum,
          imageUrl: friendDoc['image_url']);
      final id = chat['chatId'];
      setState(() {
        chats.add(Chat(user1: myUser, user2: user2, chatId: id));
      });
    }
    for (final chat in query2.docs) {
      final friendNum = chat['user1'];
      final friendQuery = await firestore
          .collection('users')
          .where('number', isEqualTo: friendNum)
          .get();
      final friendDoc = friendQuery.docs[0].data();
      ChatUser user2 = ChatUser(
          name: friendDoc['username'],
          number: friendNum,
          imageUrl: friendDoc['image_url']);
      final id = chat['chatId'];
      setState(() {
        chats.add(Chat(user1: user2, user2: myUser, chatId: id));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAlertDialog(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: 400,
          child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: ((context, index) {
                final chat = chats[index];
                final friend =
                    currentUser == chat.user1.number ? chat.user2 : chat.user1;
                return Padding(
                    padding: EdgeInsets.all(5), child: ChatTray(chat, friend));
              })),
        ),
      ),
    );
  }
}
