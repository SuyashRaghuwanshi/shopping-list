import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Drawer(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.5),
                          Theme.of(context).colorScheme.primaryContainer
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_sharp,
                          size: 50,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Chatify',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 30),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Chatting App made with flutter and firebase',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                    leading: const Icon(Icons.android),
                  ),
                ],
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ListTile(
                      title: Text(
                        '2024. Dheeraj Solanki',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      leading: const Icon(Icons.copyright_outlined),
                    ),
                  ),
                ],
              )
            ]),
      ),
    );
  }
}
