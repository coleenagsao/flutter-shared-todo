/*
  Author: Coleen Therese A. Agsao
  Section: CMSC 23 D5L
  Exercise number: Project
  Description: Shared todo app with friends system
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> usersStream = context.watch<UserListProvider>().users;

    Widget friendsList = StreamBuilder(
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
            String currentUserId =
                Provider.of<AuthProvider>(context, listen: false)
                    .userId
                    .toString();

            //only display the widgets if not user's and user is in current users' friends
            if (user.userId.toString() != currentUserId &&
                (user.friends.any((item) => item.contains(currentUserId)))) {
              return ListTile(
                title: Text(
                  "${user.fname} ${user.lname}",
                ),
                leading: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        builder: (context) {
                          return FractionallySizedBox(
                              heightFactor: 0.8,
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                child: Row(
                                  children: [
                                    Expanded(
                                        /*1*/
                                        child: Container(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  130, 1, 130, 20),
                                              child: Container(
                                                  height: 8.0,
                                                  width: 100.0,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[300],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)))),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
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
                                            title: Text(
                                                "${user.fname} ${user.lname}"),
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
                                    )),
                                  ],
                                ),
                              ));
                        });
                  },
                  icon: const Icon(Icons.person),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          //change the selected user
                          context
                              .read<UserListProvider>()
                              .changeSelectedUser(user);
                          //call the function to unfriend
                          context
                              .read<UserListProvider>()
                              .unfriend(currentUserId);
                        },
                        child: Text("Unfriend"))
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        );
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Friends"),
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: friendsList);
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
