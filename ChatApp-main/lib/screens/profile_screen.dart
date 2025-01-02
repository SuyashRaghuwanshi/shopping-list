import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final doc = snapshot.data!.docs[0].data();
          return ProfileView(
              ChatUser(
                  name: doc['username'],
                  number: doc['number'],
                  imageUrl: doc['image_url']),
              true);
        });
  }
}
