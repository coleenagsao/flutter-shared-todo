import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    //text controllers
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController fnameController = TextEditingController();
    TextEditingController lnameController = TextEditingController();
    TextEditingController unameController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController locController = TextEditingController();
    TextEditingController bioController = TextEditingController();

    //error checking
    List emailErrors = [
      "Invalid email.",
      'The account already exists for that email.',
      "Fill out your email.",
      'Internal error occurred',
      "Server is handling too many requests. Try again later",
      "Enter your desired email."
    ];
    List passwordErrors = [
      "The password provided is too weak.",
      "Wrong password provided for that user.",
      "Fill out your password.",
      'Internal error occurred',
      "Server is handling too many requests. Try again later",
      "Enter your desired password.",
      "Min. 8 characters, 1 uppercase, 1 lowercase, 1 no, and 1 special char required."
    ];

    String? extractErrorMessage(dynamic code) {
      switch (code) {
        //email errors
        case 'invalid-email':
          return 'Invalid email.';
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

    final fname = TextField(
      key: const Key('fnameField'),
      controller: fnameController,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: "First Name",
          errorText:
              _errorMessage == "Enter your first name." ? _errorMessage : null),
    );

    final lname = TextField(
      key: const Key('lnameField'),
      controller: lnameController,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: "Last Name",
          errorText:
              _errorMessage == "Enter your last name." ? _errorMessage : null),
    );

    final uname = TextField(
      controller: unameController,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.verified_user),
          hintText: "Username",
          errorText:
              _errorMessage == "Enter your username." ? _errorMessage : null),
    );

    final loc = TextField(
      controller: locController,
      decoration: InputDecoration(
          //Nicanica28!
          prefixIcon: Icon(Icons.location_city),
          hintText: "Location",
          errorText:
              _errorMessage == "Enter your location" ? _errorMessage : null),
    );

    final bio = TextField(
      controller: bioController,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.lightbulb),
          hintText: "Bio",
          errorText: _errorMessage == "Enter your bio." ? _errorMessage : null),
    );

    final bdate = TextField(
        readOnly: true,
        controller: dateController,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.date_range),
            hintText: 'Birthday',
            errorText:
                _errorMessage == "Enter your birthday." ? _errorMessage : null),
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
          errorText: (passwordErrors.any((item) => item == _errorMessage)
              ? _errorMessage
              : null)),
    );

    //generate search keyword possibilities
    setSearchParam(String caseNumber) {
      List<String> caseSearchList = [];
      String temp = "";
      for (int i = 0; i < caseNumber.length; i++) {
        temp = temp + caseNumber[i];
        caseSearchList.add(temp);
      }
      return caseSearchList;
    }

    bool validatePasswordStructure(String value) {
      String pattern =
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(value);
    }

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          //check for usual errors (not on server)
          if (fnameController.text == "") {
            setState(() {
              _errorMessage = "Enter your first name.";
              print("Sign up Field: $_errorMessage");
            });
          } else if (lnameController.text == "") {
            setState(() {
              _errorMessage = "Enter your last name.";
              print("Sign up Field: $_errorMessage");
            });
          } else if (unameController.text == "") {
            setState(() {
              _errorMessage = "Enter your username.";
              print("Sign up Field: $_errorMessage");
            });
          } else if (locController.text == "") {
            setState(() {
              _errorMessage = "Enter your location.";
              print("Sign up Field: $_errorMessage");
            });
          } else if (bioController.text == "") {
            setState(() {
              _errorMessage = "Enter your bio.";
              print("Sign up Field: $_errorMessage");
            });
          } else if (dateController.text == "") {
            setState(() {
              _errorMessage = "Enter your birthday.";
              print("Sign up Field: $_errorMessage");
            });
          } else if (emailController.text == "") {
            setState(() {
              _errorMessage = "Enter your desired email.";
              print("Sign up Email Error: $_errorMessage");
            });
          } else if (passwordController.text == "") {
            setState(() {
              _errorMessage = "Enter your desired password.";
              print("Sign up Password Error: $_errorMessage");
            });
          } else if (!validatePasswordStructure(passwordController.text)) {
            setState(() {
              _errorMessage =
                  "Min. 8 characters, 1 uppercase, 1 lowercase, 1 no, and 1 special char required.";
              print("Sign up Password Error: $_errorMessage");
            });
          } else {
            List searchKeywords = setSearchParam(
                '${fnameController.text} ${lnameController.text}');

            dynamic result = await context.read<AuthProvider>().signUp(
                emailController.text,
                passwordController.text,
                fnameController.text,
                lnameController.text,
                unameController.text,
                dateController.text,
                locController.text,
                bioController.text,
                searchKeywords);

            setState(() {
              if (result == null) {
                print("Sucessfully created user");
                Navigator.pop(context);
              } else {
                _errorMessage = extractErrorMessage(result);
                print("Sign up Error from Firebase: $_errorMessage");
              }
            });
          }
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
        style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            backgroundColor: Color.fromRGBO(48, 56, 76, 1)),
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
            Row(children: [
              const Text(
                "Sign up to  ",
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
              'images/signup.png',
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
            Row(children: [SignupButton, Text("  "), backButton])
          ],
        ),
      ),
    );
  }
}
