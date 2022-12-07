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
                              Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${user.fname} ${user.lname}',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '@${user.uname}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                              ),
                              const Text(" "),
                              Text(
                                '${user.bio}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                              ),
                              const Text(" "),
                              const Divider(),
                              const Text(" "),
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
                              _buildInfoBlock(Icons.cake_rounded, user.bdate),
                              _buildInfoBlock(Icons.location_pin, user.loc)
                            ],
                          ),
                        ),
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

_buildInfoBlock(icon, info) {
  //temp
  return Row(children: [
    Icon(
      icon,
      color: Colors.grey[500],
    ),
    Text(
      '  ${info}',
      style: TextStyle(
        color: Colors.grey[500],
      ),
    ),
  ]);
}
