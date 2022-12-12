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
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    Stream<QuerySnapshot> userStream = context.watch<UserListProvider>().users;

    Widget myTasks = Text("My Tasks");
    Widget friendsTasks = Text("Friends' Tasks");

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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications),
            label: 'Feed',
          ),
        ],
      ),
      body: <Widget>[
        Container(alignment: Alignment.center, child: myTasks),
        Container(
          color: Colors.green,
          alignment: Alignment.center,
          child: friendsTasks,
        ),
      ][currentPageIndex],
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
}








//References:
// https://blog.logrocket.com/how-to-add-navigation-drawer-flutter/

