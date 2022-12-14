import 'package:flutter/material.dart';
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

    List emailErrors = [
      "No user found for that email.",
      'The account already exists for that email.',
      "Fill out your email.",
      'Internal error occurred',
      "Server is handling too many requests. Try again later"
    ];
    List passwordErrors = [
      "The password provided is too weak.",
      "Wrong password provided for that user.",
      "Fill out your password.",
      'Internal error occurred',
      "Server is handling too many requests. Try again later"
    ];

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
      controller: emailController,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          hintText: "Email",
          errorText: (emailErrors.any((item) => item == _errorMessage))
              ? _errorMessage
              : null),
    );

    final password = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key),
          hintText: 'Password',
          errorText: (passwordErrors.any((item) => item == _errorMessage))
              ? _errorMessage
              : null),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (emailController.text == "") {
            setState(() {
              _errorMessage = "Fill out your email.";
              print("Email Check in Client: $_errorMessage");
            });
          } else if (passwordController.text == "") {
            setState(() {
              _errorMessage = "Fill out your password.";
              print("Password Check in Client: $_errorMessage");
            });
          } else {
            String result = await context
                .read<AuthProvider>()
                .signIn(emailController.text, passwordController.text);
            setState(() {
              _errorMessage = extractErrorMessage(result);
              //print("Login: $_errorMessage");
            });
          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(shape: StadiumBorder()),
      ),
    );

    final signupButton = Padding(
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
          style: ElevatedButton.styleFrom(shape: StadiumBorder()),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
              bottom: 40, top: 100.0, left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "LOG IN TO BRIDGE",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'assets/images/login.jpg',
              width: 600,
              height: 400,
            ),
            email,
            password,
            loginButton,
            signupButton,
          ],
        ),
      ),
    );
  }
}
