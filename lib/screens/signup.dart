import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController fnameController = TextEditingController();
    TextEditingController lnameController = TextEditingController();
    TextEditingController unameController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController locController = TextEditingController();

    final fname = TextField(
      controller: fnameController,
      decoration: const InputDecoration(
        hintText: "First Name",
      ),
    );

    final lname = TextField(
      controller: lnameController,
      decoration: const InputDecoration(
        hintText: "Last Name",
      ),
    );

    final uname = TextField(
      controller: unameController,
      decoration: const InputDecoration(
        hintText: "Username",
      ),
    );

    final loc = TextField(
      controller: locController,
      decoration: const InputDecoration(
        hintText: "Location",
      ),
    );

    final bdate = TextField(
        readOnly: true,
        controller: dateController,
        decoration: InputDecoration(hintText: 'Birthday'),
        onTap: () async {
          var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          dateController.text = date.toString().substring(0, 10);
        });

    final email = TextField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );

    final password = TextField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
    );

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthProvider>().signUp(
              emailController.text,
              passwordController.text,
              fnameController.text,
              lnameController.text,
              unameController.text,
              dateController.text,
              locController.text);
          Navigator.pop(context);
          //call the auth provider here
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
          //call the auth provider here
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            fname,
            lname,
            uname,
            bdate,
            loc,
            email,
            password,
            SignupButton,
            backButton
          ],
        ),
      ),
    );
  }
}
