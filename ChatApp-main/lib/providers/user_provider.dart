import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider =
    Provider.family<AsyncValue<ChatUser>, String>((ref, userId) {
  return ref.watch(_userFutureProvider(userId));
});

final _userFutureProvider =
    FutureProvider.family<ChatUser, String>((ref, userId) async {
  final docSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('id', isEqualTo: userId)
      .get();

  final doc = docSnapshot.docs[0].data();
  return ChatUser(
    name: doc['username'],
    number: doc['number'],
    imageUrl: doc['image_url'],
  );
});
