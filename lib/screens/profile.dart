import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class Profile extends StatelessWidget {
  final String? userId;
  const Profile({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> usersStream = context.watch<UserListProvider>().users;

    return MaterialApp(
      title: "About Me",
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Colors.grey,
        fontFamily: 'Helvetica',
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 20.0),
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
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("No Users Found."),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                User user = User.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
                if (user.userId.toString() == userId) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        Expanded(
                          /*1*/
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*2*/
                              Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${user.fname}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '${user.loc}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*3*/
                        Icon(
                          Icons.cake_rounded,
                          color: Colors.blueGrey,
                        ),
                        Text('${user.bdate}'),
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
