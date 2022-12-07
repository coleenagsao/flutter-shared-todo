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
    TextEditingController bioController = TextEditingController();

    final fname = TextField(
      controller: fnameController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: "First Name",
      ),
    );

    final lname = TextField(
      controller: lnameController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: "Last Name",
      ),
    );

    final uname = TextField(
      controller: unameController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.verified_user),
        hintText: "Username",
      ),
    );

    final loc = TextField(
      controller: locController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.location_city),
        hintText: "Location",
      ),
    );

    final bio = TextField(
      controller: bioController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.lightbulb),
        hintText: "Bio",
      ),
    );

    final bdate = TextField(
        readOnly: true,
        controller: dateController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.date_range), hintText: 'Birthday'),
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
              locController.text,
              bioController.text);
          Navigator.pop(context);
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(shape: StadiumBorder()),
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
        style: ElevatedButton.styleFrom(shape: StadiumBorder()),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
              bottom: 40, top: 100.0, left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "SIGN UP TO BRIDGE",
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
            fname,
            lname,
            uname,
            bio,
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
