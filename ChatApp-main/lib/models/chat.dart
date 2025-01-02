import 'package:chat_app/models/chat_user.dart';

class Chat {
  Chat({required this.user1, required this.user2, required this.chatId});
  String chatId;
  ChatUser user1;
  ChatUser user2;
}
