import 'dart:io';

import 'package:chat_app/models/chat.dart';
import 'package:chat_app/widgets/image_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

final firestore = FirebaseFirestore.instance;

class NewMessage extends StatefulWidget {
  NewMessage({super.key, required this.chat});

  final Chat chat;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  State<NewMessage> createState() {
    return _NewMessagetate();
  }
}

class _NewMessagetate extends State<NewMessage> {
  final _messageController = TextEditingController();

  File? _pickedImageFile;

  ImageSource? source;

  void _pickImage() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Pick Image Source',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text('Camera'),
                    onTap: () {
                      source = ImageSource.camera;
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      source = ImageSource.gallery;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
    if (source == null) return;
    final imagePicker = ImagePicker();
    final pickImage = await imagePicker.pickImage(
        source: source!, imageQuality: 100, maxWidth: 300);

    if (pickImage == null) return;

    setState(() {
      _pickedImageFile = File(pickImage.path);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onImageSend(File pickedImage) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${widget.chat.chatId}${widget.userId}${Timestamp.now()}.jpg');
    await storageRef.putFile(pickedImage);
    final imageUrl = await storageRef.getDownloadURL();
    final myUser = FirebaseAuth.instance.currentUser!;
    final chat = widget.chat;

    firestore.collection('chats').doc(chat.chatId).collection('messages').add({
      'image': imageUrl,
      'userId': myUser.uid,
      'sentAt': Timestamp.now(),
    });
  }

  void _sendMessage() {
    final message = _messageController.text;

    if (message.trim().isEmpty) {
      return;
    }

    final myUser = FirebaseAuth.instance.currentUser!;
    final chat = widget.chat;

    firestore.collection('chats').doc(chat.chatId).collection('messages').add({
      'text': message,
      'userId': myUser.uid,
      'sentAt': Timestamp.now(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_pickedImageFile != null) {
      return NewImageMessage(
          pickedImage: _pickedImageFile!,
          onCancel: () {
            setState(() {
              _pickedImageFile = null;
            });
          },
          onSend: () {
            _onImageSend(_pickedImageFile!);
            setState(() {
              _pickedImageFile = null;
            });
          });
    }
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 10, top: 8, bottom: 12),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Color.fromARGB(255, 56, 56, 56),
              ),
              IconButton(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_camera),
                color: Colors.white,
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17),
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  hintText: 'Send a message',
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 17,
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withAlpha(220))),
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Color.fromARGB(255, 56, 56, 56),
              ),
              IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
              )
            ],
          )
        ],
      ),
    );
  }
}
