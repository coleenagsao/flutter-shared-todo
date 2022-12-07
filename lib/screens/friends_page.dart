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
            if (user.userId.toString() != currentUserId &&
                (user.friends.any((item) => item.contains(currentUserId)))) {
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
                          //add current user id to this user's friend request
                          context
                              .read<UserListProvider>()
                              .changeSelectedUser(user);
                          context
                              .read<UserListProvider>()
                              .unfriend(currentUserId);
                        },
                        child: Text("Unfriend"))
                  ],
                ),
              );
            } else {
              return Text("");
            }
          }),
        );
      },
    );
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
                !(user.sentFriendRequests
                    .any((item) => item.contains(currentUserId))) &&
                !(user.friends.any((item) => item.contains(currentUserId)))) {
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
              return Text(" ");
            }
          }),
        );
      },
    );
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
                          user.receivedFriendRequests.add(currentUserId);
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
        title: Text("Bridgers"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          friendsList = rebuildFriends(usersStream, context);
          friendRequestsList = rebuildFriends(usersStream, context);
          suggestionsList = rebuildFriends(usersStream, context);

          setState(() {
            currentPageIndex = index;
            friendsList = rebuildFriends(usersStream, context);
            friendRequestsList = rebuildFriends(usersStream, context);
            suggestionsList = rebuildFriends(usersStream, context);
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Friend Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Friends',
          ),
          NavigationDestination(
            //selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.explore),
            label: 'Suggestions',
          ),
        ],
      ),
      body: <Widget>[
        Container(
            alignment: Alignment.center,
            child: rebuildFriends(usersStream, context)),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: rebuildFriends(usersStream, context),
        ),
        Container(
          alignment: Alignment.center,
          child: suggestionsList,
        ),
      ][currentPageIndex],
    );
  }
}

rebuildFriends(Stream<QuerySnapshot> usersStream, BuildContext context) {
  return StreamBuilder(
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
              (user.friends.any((item) => item.contains(currentUserId)))) {
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
                        //add current user id to this user's friend request
                        context
                            .read<UserListProvider>()
                            .changeSelectedUser(user);
                        context
                            .read<UserListProvider>()
                            .unfriend(currentUserId);
                      },
                      child: Text("Unfriend"))
                ],
              ),
            );
          } else {
            return Text("");
          }
        }),
      );
    },
  );
}
