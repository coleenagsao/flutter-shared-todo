import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:provider/provider.dart';

// https://medium.flutterdevs.com/implement-searching-with-firebase-firestore-flutter-de7ebd53c8c9

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
                    (user.friends
                        .any((item) => item.contains(currentUserId)))) {
                  return Card(
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          '${user.fname}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text("");
                }
              }),
            );
          },
        ));
  }
}
