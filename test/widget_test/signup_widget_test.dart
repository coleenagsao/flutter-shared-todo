import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/main.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/signup.dart';

void main() {
  // Define a test
  testWidgets('Test Signup Fields ', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => TodoListProvider())),
          ChangeNotifierProvider(create: ((context) => AuthProvider())),
          ChangeNotifierProvider(create: ((context) => UserListProvider())),
        ],
        child: MyApp(),
      ),
    );

    //final screenDisplay = find.text('Login');
    final fnameField = find.byKey(const Key("fnameField"));
    // final lnameField = find.byKey(const Key("lname"));
    // final loginButton = find.byKey(const Key("loginButton"));
    // final signUpButton = find.byKey(const Key("signUpButton"));

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets and Button widgets appear exactly once in the widget tree.
    // expect(screenDisplay, findsOneWidget);
    expect(fnameField, findsOneWidget);
    // expect(lnameField, findsOneWidget);
    // expect(loginButton, findsOneWidget);
    // expect(signUpButton, findsOneWidget);
    // await tester.tap(signUpButton);

    // final signinDisplay = find.text('Sign Up');
    // expect(signinDisplay, findsOneWidget);
  });
}
