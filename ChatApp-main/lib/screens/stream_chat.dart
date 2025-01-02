import 'package:chat_app/widgets/chat_list.dart';
import 'package:flutter/material.dart';

class StreamChat extends StatelessWidget {
  const StreamChat({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ChatList(),
    );
  }
}
