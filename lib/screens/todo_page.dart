/*
  Created by: Claizel Coubeili Cepe
  Date: 27 October 2022
  Description: Sample todo app with networking
*/

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/api/firebase_todo_api.dart';
import 'dart:core';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_model.dart';
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
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    Stream<QuerySnapshot> userStream = context.watch<UserListProvider>().users;

    Widget myTasks = StreamBuilder(
      stream: FirebaseFirestore.instance.collection("todos").snapshots(),
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
            Todo todo = Todo.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>);
            String currentUserId =
                Provider.of<AuthProvider>(context, listen: false)
                    .userId
                    .toString();

            if (todo.userId == currentUserId) {
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
                            Icon(CupertinoIcons.person_alt_circle,
                                color: Colors.blue),
                            Text(" ${todo.userId}",
                                style: TextStyle(
                                    fontSize: 14,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.grey))
                          ],
                        )
                      ]),
                  leading: todo.completed == true
                      ? IconButton(
                          onPressed: () {
                            context
                                .read<TodoListProvider>()
                                .changeSelectedTodo(todo);
                            context
                                .read<TodoListProvider>()
                                .toggleStatus(!todo.completed);
                          },
                          icon: Icon(
                            CupertinoIcons.check_mark_circled,
                            color: Colors.green,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            context
                                .read<TodoListProvider>()
                                .changeSelectedTodo(todo);
                            context
                                .read<TodoListProvider>()
                                .toggleStatus(!todo.completed);
                          },
                          icon: Icon(
                            CupertinoIcons.xmark_circle,
                            color: Colors.orange,
                          ),
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
                          CupertinoIcons.pencil_circle,
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
                        icon: Icon(CupertinoIcons.delete_left,
                            color: Colors.blue),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Text(" ");
            }
          }),
        );
      },
    );

    //Widget myTasks = Text("Friends");
    Widget friendsTasks = StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
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
            User user = User.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>);
            String currentUserId =
                Provider.of<AuthProvider>(context, listen: false)
                    .userId
                    .toString();
            //context.read<UserListProvider>().changeSelectedFriend(user);

            if (user.userId == currentUserId) {
              return StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("todos").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Error encountered! ${snapshot.error}"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text("No Todos Found"),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      Todo todo = Todo.fromJson(snapshot.data?.docs[index]
                          .data() as Map<String, dynamic>);
                      String currentUserId =
                          Provider.of<AuthProvider>(context, listen: false)
                              .userId
                              .toString();

                      if (user.friends
                          .any((item) => item.contains(todo.userId))) {
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
                                      Icon(CupertinoIcons.person_alt_circle,
                                          color: Colors.blue),
                                      Text(todo.userId,
                                          style: TextStyle(
                                              fontSize: 14,
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.grey))
                                    ],
                                  )
                                ]),
                            leading: todo.completed == true
                                ? Icon(
                                    CupertinoIcons.check_mark_circled,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    CupertinoIcons.xmark_circle,
                                    color: Colors.orange,
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
                                      builder: (BuildContext context) =>
                                          TodoModal(
                                        type: 'Edit',
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    CupertinoIcons.pencil_circle,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text("");
                      }
                    }),
                  );
                },
              );
            } else {
              return const Text(" ");
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
            color: Color.fromRGBO(48, 56, 76, 1),
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
          leading: Icon(CupertinoIcons.eject),
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
                leading: Icon(CupertinoIcons.search),
                title: const Text('Search'),
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                }),
            ListTile(
                leading: Icon(CupertinoIcons.person_3),
                title: const Text('Friends'),
                onTap: () {
                  Navigator.pushNamed(context, '/friends');
                }),
            ListTile(
                leading: Icon(CupertinoIcons.flag),
                title: const Text('Friend requests'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/friendreqs');
                }),
            ListTile(
                leading: Icon(CupertinoIcons.link),
                title: const Text('People you may know'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/suggestions');
                }),
          ],
        ),
        const AboutListTile(
          icon: Icon(
            CupertinoIcons.info_circle,
          ),
          child: Text('About App'),
          applicationIcon: Icon(
            CupertinoIcons.info_circle,
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
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(CupertinoIcons.person_2_square_stack),
            label: 'Feed',
          ),
        ],
      ),
      body: <Widget>[
        Container(
            alignment: Alignment.center,
            color: Color(0xff30384c),
            child: myTasks),
        Container(
          color: Color(0xff30384c),
          alignment: Alignment.center,
          child: friendsTasks,
        ),
      ][currentPageIndex],
      floatingActionButton: currentPageIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => TodoModal(
                    type: 'Add',
                  ),
                );
              },
              child: const Icon(CupertinoIcons.add),
            )
          : null,
    );
  }
}


//References:
// https://blog.logrocket.com/how-to-add-navigation-drawer-flutter/

