import 'package:chat_app/screens/sign_up.dart';
import 'package:chat_app/screens/tab_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

final theme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 20, 19, 19),
  ),
  textTheme: GoogleFonts.ubuntuTextTheme().copyWith(),
);

final darkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(156, 193, 3, 3),
      brightness: Brightness.dark,
      onBackground: Colors.white),
  textTheme: GoogleFonts.ubuntuTextTheme(),
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.transparent,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: theme,
      darkTheme: darkTheme,
      home: FirebaseAuth.instance.currentUser == null
          ? const SignUpScreen()
          : const TabsScreen(),
    );
  }
}
