import 'dart:io';

import 'package:flutter/material.dart';

class NewImageMessage extends StatelessWidget {
  const NewImageMessage(
      {required this.pickedImage,
      required this.onCancel,
      required this.onSend,
      super.key});

  final File pickedImage;

  final void Function() onCancel;

  final void Function() onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5, top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                radius: 26,
              ),
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel),
                color: Theme.of(context).colorScheme.secondary,
              )
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 200,
            child: Image(image: FileImage(pickedImage)),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              const CircleAvatar(
                radius: 26,
              ),
              IconButton(
                onPressed: onSend,
                icon: const Icon(Icons.send_rounded),
                color: Theme.of(context).colorScheme.primary,
              )
            ],
          )
        ],
      ),
    );
  }
}
