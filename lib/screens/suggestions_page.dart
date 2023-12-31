import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> usersStream = context.watch<UserListProvider>().users;

    Widget suggestionsList = StreamBuilder(
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
                !(user.friends.any((item) => item.contains(currentUserId))) &&
                !(user.receivedFriendRequests
                    .any((item) => item.contains(currentUserId))) &&
                !(user.friends.any((item) => item.contains(currentUserId))) &&
                !(user.sentFriendRequests
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
                          //add current user id to this user's friend request
                          context
                              .read<UserListProvider>()
                              .changeSelectedUser(user);
                          context
                              .read<UserListProvider>()
                              .addFriendRequest(currentUserId);
                          user.receivedFriendRequests.add(currentUserId);
                        },
                        child: Text("Add Friend"))
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
          title: Text("People you may know"),
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: suggestionsList);
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
