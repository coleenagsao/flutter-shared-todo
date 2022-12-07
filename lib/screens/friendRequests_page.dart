import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:provider/provider.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> usersStream = context.watch<UserListProvider>().users;

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
                  onPressed: () {},
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
                          context
                              .read<UserListProvider>()
                              .deleteFriendRequest(currentUserId);
                        },
                        child: Text("Delete"))
                  ],
                ),
              );
            } else {
              return Text(" ");
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
