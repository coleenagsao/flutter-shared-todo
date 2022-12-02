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
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final email = TextField(
      controller: emailController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: "Email",
      ),
    );

    final password = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.key),
        hintText: 'Password',
      ),
    );

    final loginButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          context
              .read<AuthProvider>()
              .signIn(emailController.text, passwordController.text);
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
              bottom: 40, top: 40.0, left: 40.0, right: 40.0),
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
              'images/login.jpg',
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
