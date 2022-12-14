/*
  Author: Coleen Therese A. Agsao
  Section: CMSC 23 D5L
  Exercise number: Project
  Description: Shared todo app with friends system
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class Profile extends StatelessWidget {
  final String? userId;
  const Profile({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> usersStream = context.watch<UserListProvider>().users;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Profile",
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: StreamBuilder(
          stream: usersStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error encountered! ${snapshot.error}"),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text("No Users Found."),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                User user = User.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);

                //display the info of the user if matched with the userId converted
                if (user.userId.toString() == userId) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '@${user.uname}',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text("${user.fname} ${user.lname}"),
                          subtitle: Text("Name"),
                        ),
                        ListTile(
                          title: Text("${user.email}"),
                          subtitle: Text("Email"),
                        ),
                        ListTile(
                          title: Text("${user.bio}"),
                          subtitle: Text("Bio"),
                        ),
                        ListTile(
                          title: Text("${user.loc}"),
                          subtitle: Text("Location"),
                        ),
                        ListTile(
                          title: Text("${user.bdate}"),
                          subtitle: Text("Birthday"),
                        ),
                        const Divider(),
                        Row(children: [
                          Icon(
                            Icons.info_rounded,
                            color: Colors.grey[500],
                          ),
                          Text(
                            '  ${user.userId}',
                            style: TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ]),
                      ],
                    ),
                  );
                } else {
                  return Text(" ");
                }
              }),
            );
          },
        ),
      ),
    );
  }
}
