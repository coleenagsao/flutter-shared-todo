/*
  Author: Coleen Therese A. Agsao
  Section: CMSC 23 D5L
  Exercise number: Project
  Description: Shared todo app with friends system
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/friendRequests_page.dart';
import 'package:week7_networking_discussion/screens/friends_page.dart';
import 'package:week7_networking_discussion/screens/profile.dart';
import 'package:week7_networking_discussion/screens/search_page.dart';
import 'package:week7_networking_discussion/screens/suggestions_page.dart';
import 'package:week7_networking_discussion/screens/todo_page.dart';
import 'package:week7_networking_discussion/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //to be commented for the test
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
        ChangeNotifierProvider(create: ((context) => AuthProvider())),
        ChangeNotifierProvider(create: ((context) => UserListProvider())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //removes the banner at the app bar
      title: 'Bridge',
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/profile': (context) =>
            Profile(userId: context.watch<AuthProvider>().userId),
        '/friends': (context) => const FriendsPage(),
        '/friendreqs': (context) => const FriendRequestsPage(),
        '/suggestions': (context) => const SuggestionsPage(),
        '/search': (context) => SearchPage()
      },
      theme: ThemeData(
        primarySwatch: Colors.green, //set main theme to green
        textTheme: GoogleFonts.latoTextTheme(
          //set font to lato
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      print("Logged in user with uid ${context.watch<AuthProvider>().userId}");
      return const TodoPage();
    } else {
      return const LoginPage();
    }
  }
}
