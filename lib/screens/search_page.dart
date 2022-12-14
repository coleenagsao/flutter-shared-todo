/*
  Author: Coleen Therese A. Agsao
  Section: CMSC 23 D5L
  Exercise number: Project
  Description: Shared todo app with friends system
  Reference: // https://medium.flutterdevs.com/implement-searching-with-firebase-firestore-flutter-de7ebd53c8c9

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> usersStream = context.watch<UserListProvider>().users;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Card(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
        ),
        body: StreamBuilder(
          //access directly the search keywords for the user's name
          stream: (name != "")
              ? FirebaseFirestore.instance
                  .collection("users")
                  .where("searchKeywords", arrayContains: name)
                  .snapshots()
              : FirebaseFirestore.instance.collection('users').snapshots(),
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

                //display the data if not the current user
                if (user.userId.toString() != currentUserId) {
                  //if already friend, no button beside name. If not friend, display tile with add button
                  if (user.friends
                      .any((item) => item.contains(currentUserId))) {
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
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            130, 1, 130, 20),
                                                    child: Container(
                                                        height: 8.0,
                                                        width: 100.0,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[300],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0)))),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8),
                                                  child: Text(
                                                    '@${user.uname}',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                    );
                  } else {
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
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            130, 5, 130, 20),
                                                    child: Container(
                                                        height: 8.0,
                                                        width: 100.0,
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[300],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0)))),
                                                /*2*/
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8),
                                                  child: Text(
                                                    '${user.fname} ${user.lname}',
                                                    style: TextStyle(
                                                      color: Colors.blue[700],
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                const Divider(),
                                                Text(
                                                  '${user.bio}',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 16,
                                                  ),
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
                                                _buildInfoBlock(
                                                    Icons.cake_rounded,
                                                    user.bdate),
                                                _buildInfoBlock(
                                                    Icons.location_pin,
                                                    user.loc)
                                              ],
                                            ),
                                          ),
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
                                //add current user id to this user's friend request
                                context
                                    .read<UserListProvider>()
                                    .changeSelectedUser(user);
                                context
                                    .read<UserListProvider>()
                                    .addFriendRequest(currentUserId);
                              },
                              child: Text("Add Friend"))
                        ],
                      ),
                    );
                  }
                } else {
                  return SizedBox.shrink();
                }
              }),
            );
          },
        ));
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
