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
import 'package:week7_networking_discussion/screens/profile.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  int currentPageIndex = 0; //counter for the page to load

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> usersStream =
        context.watch<UserListProvider>().users; //get users

    Widget friendRequestsList = StreamBuilder(
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
            if (user.userId.toString() != currentUserId &&
                (user.sentFriendRequests
                    .any((item) => item.contains(currentUserId)))) {
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
                          //add both to friends list, then remove in received and sent friend requests
                          context
                              .read<UserListProvider>()
                              .changeSelectedUser(user);
                          context
                              .read<UserListProvider>()
                              .addFriend(currentUserId);
                        },
                        child: Text("Confirm")),
                    Text("  "),
                    ElevatedButton(
                        onPressed: () {
                          //add current user id to this user's friend request
                          context
                              .read<UserListProvider>()
                              .changeSelectedUser(user);
                          //delete the friend request
                          context
                              .read<UserListProvider>()
                              .deleteFriendRequest(currentUserId);
                        },
                        child: Text("Delete"))
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
          title: Text("Bridgers requests"),
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: friendRequestsList);
  }
}

_buildInfoBlock(icon, info) {
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
