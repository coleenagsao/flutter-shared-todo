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
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          accountName: Text(
            'Coleen Agsao',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            "coleenagsao@gmail.com",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
          ),
          currentAccountPicture: FlutterLogo(),
        ),
        ListTile(
            leading: Icon(Icons.person),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            }),
        ListTile(
            leading: Icon(Icons.heat_pump_rounded),
            title: const Text('Todos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            }),
        ListTile(
          leading: Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            context.read<AuthProvider>().signOut();
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        Divider(),
        AboutListTile(
          icon: Icon(
            Icons.info,
          ),
          child: Text('About App'),
          applicationIcon: Icon(
            Icons.local_play,
          ),
          applicationName: 'Bridge',
          applicationVersion: '1.0.0',
          applicationLegalese: 'CMSC 23 Project 22-23',
        )
      ])),
      appBar: AppBar(
        title: Text("Bridgers"),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Friend Requests',
          ),
          NavigationDestination(
            //selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.explore),
            label: 'Suggestions',
          ),
        ],
      ),
      body: <Widget>[
        Container(alignment: Alignment.center, child: friendsList),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: friendRequestsList,
        ),
        Container(
          alignment: Alignment.center,
          child: suggestionsList,
        ),
      ][currentPageIndex],
    );
  }
}
