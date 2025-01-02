import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/edit_screen.dart';
import 'package:chat_app/screens/sign_in.dart';
import 'package:chat_app/widgets/image_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView(this.user, this.me, {super.key});

  final ChatUser user;
  final bool me;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            user.name,
            softWrap: true,
          ),
          actions: [
            if (me)
              TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => const EditScreen()));
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  )),
          ],
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Card(
            color: Colors.transparent,
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) =>
                              ImageView(image: user.imageUrl)));
                    },
                    child: CircleAvatar(
                      radius: 140,
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Name :',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 35),
                          ),
                          Text(
                            user.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Number :',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: 35),
                          ),
                          Text(
                            user.number,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (me)
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: TextButton.icon(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (ctx) => const SignInScreen()),
                              (route) => false);
                        },
                        icon: const Icon(Icons.logout),
                        label: Text(
                          'Logout',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ));
  }
}
