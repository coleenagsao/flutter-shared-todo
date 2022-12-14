/*
  Author: Coleen Therese A. Agsao
  Section: CMSC 23 D5L
  Exercise number: Project
  Description: Shared todo app with friends system
  Base Code Used: Claizel Coubeili Cepe (27 October 2022)
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    //list of email errors to filter what will be displayed per field
    List emailErrors = [
      "No user found for that email.",
      'The account already exists for that email.',
      "Fill out your email.",
      'Internal error occurred',
      "Server is handling too many requests. Try again later"
    ];

    //list of password errors to filter what will be displayed per field
    List passwordErrors = [
      "The password provided is too weak.",
      "Wrong password provided for that user.",
      "Fill out your password.",
      'Internal error occurred',
      "Server is handling too many requests. Try again later"
    ];

    //return appropriate error message based on the e.code from the firebase
    String? extractErrorMessage(String code) {
      switch (code) {
        //email errors
        case 'invalid-email':
          return 'No user found for that email.';
        case 'email-already-in-use':
          return 'The account already exists for that email.';
        case 'user-not-found':
          return 'No user found for that email.';

        //password erros
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'wrong-password':
          return 'Wrong password provided for that user.';
        case 'internal-error':
          return 'Internal error occurred';
        case "too-many-requests":
          return "Server is handling too many requests. Try again later";
        //others
        default:
          return null;
      }
    }

    final email = TextField(
      key: const Key('emailField'),
      controller: emailController,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          hintText: "Email",
          //if errormessage set is one of the email errors, display
          errorText: (emailErrors.any((item) => item == _errorMessage))
              ? _errorMessage
              : null),
    );

    final password = TextField(
      key: const Key('pwField'),
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          hintText: 'Password',
          //if errormessage set is one of the password errors, display
          errorText: (passwordErrors.any((item) => item == _errorMessage))
              ? _errorMessage
              : null),
    );

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (emailController.text == "") {
            //check if email is empty
            setState(() {
              _errorMessage = "Fill out your email.";
              print("Email Check in Client: $_errorMessage");
            });
          } else if (passwordController.text == "") {
            //check if pwd is empty
            setState(() {
              _errorMessage = "Fill out your password.";
              print("Password Check in Client: $_errorMessage");
            });
          } else {
            String result = await context
                .read<AuthProvider>()
                .signIn(emailController.text, passwordController.text);
            setState(() {
              _errorMessage = extractErrorMessage(
                  result); //call function for the error message
              //print("Login: $_errorMessage");
            });
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
            shape: StadiumBorder(), backgroundColor: Colors.green),
      ),
    );

    final signupButton = Padding(
        key: const Key('signUpButton'),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignupPage(),
              ),
            );
          },
          child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor: Color(0xff30384c),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
              bottom: 40, top: 100.0, left: 40.0, right: 40.0),
          children: <Widget>[
            Row(children: [
              const Text(
                "Login to  ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(48, 56, 76, 1),
                ),
              ),
              Text(
                "BRIDGE",
                textAlign: TextAlign.center,
                style: GoogleFonts.play(
                    textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
              ),
              Text(
                ".",
                textAlign: TextAlign.center,
                style: GoogleFonts.play(
                    textStyle: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(48, 56, 76, 1))),
              ),
            ]),
            Image.asset(
              'assets/images/login.png',
              width: 600,
              height: 400,
            ),
            email,
            password,
            Row(children: [loginButton, Text("  "), signupButton]),
          ],
        ),
      ),
    );
  }
}
