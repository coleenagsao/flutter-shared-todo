/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    // Stream<QuerySnapshot> userStream = context.watch<UserListProvider>().user;

    return Scaffold(
      drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Color(0xff30384c),
          ),
          accountName: Text(
            'Bridge',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          accountEmail: Text(
            "Connect your todo with others",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
          ),
          currentAccountPicture: FlutterLogo(),
        ),
        ListTile(
            leading: Icon(Icons.person_outline),
            title: const Text('User Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            }),
        ListTile(
          leading: Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            context.read<AuthProvider>().signOut();
            Navigator.pop(context);
          },
        ),
        ExpansionTile(
          title: Text("Friends"),
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.search_outlined),
                title: const Text('Search'),
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                }),
            ListTile(
                leading: Icon(Icons.people_outline),
                title: const Text('Friends'),
                onTap: () {
                  Navigator.pushNamed(context, '/friends');
                }),
            ListTile(
                leading: Icon(Icons.inbox_outlined),
                title: const Text('Friend requests'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/friendreqs');
                }),
            ListTile(
                leading: Icon(Icons.outbox_outlined),
                title: const Text('People you may know'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/suggestions');
                }),
          ],
        ),
        const AboutListTile(
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
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Color(0xFFFFFFFF),
          title: Center(
            child: FlutterLogo(),
          ),
          actions: [
            PopupMenuButton(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                      .copyWith(topRight: Radius.circular(0))),
              padding: EdgeInsets.all(10),
              elevation: 10,
              color: Colors.grey.shade100,
              onSelected: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$value item pressed')));
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      padding: EdgeInsets.only(right: 50, left: 20),
                      value: 'Home',
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.home,
                                size: 20,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'My Tasks',
                                style: TextStyle(
                                    color: Color(0xff885566),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ])
                          ]))
                ];
              },
            )
          ]),
      body: Container(
          padding: EdgeInsets.all(30),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Color(0xff30384c)),
          child: StreamBuilder(
            stream: todosStream,
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
                  child: Text("No Todos Found"),
                );
              }

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  Todo todo = Todo.fromJson(snapshot.data?.docs[index].data()
                      as Map<String, dynamic>);
                  String currentUserId =
                      Provider.of<AuthProvider>(context, listen: false)
                          .userId
                          .toString();
                  return Container(
                    padding: EdgeInsets.only(top: 20),
                    child: ListTile(
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(todo.title,
                                style: TextStyle(
                                    fontSize: 18,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            Row(
                              children: [
                                Icon(CupertinoIcons.person, color: Colors.grey),
                                Text(todo.userId,
                                    style: TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.grey))
                              ],
                            )
                          ]),
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (bool? value) {
                          context
                              .read<TodoListProvider>()
                              .changeSelectedTodo(todo);
                          context.read<TodoListProvider>().toggleStatus(value!);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              context
                                  .read<TodoListProvider>()
                                  .changeSelectedTodo(todo);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => TodoModal(
                                  type: 'Edit',
                                ),
                              );
                            },
                            icon: Icon(
                              CupertinoIcons.pencil,
                              color: Colors.blue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (todo.userId == currentUserId) {
                                //only user can delete
                                context
                                    .read<TodoListProvider>()
                                    .changeSelectedTodo(todo);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => TodoModal(
                                    type: 'Delete',
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'You can only delete your own tasks.')));
                              }
                            },
                            icon: Icon(CupertinoIcons.delete_solid,
                                color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(
              type: 'Add',
            ),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

//References:
// https://blog.logrocket.com/how-to-add-navigation-drawer-flutter/
