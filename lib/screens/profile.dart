import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_provider.dart';
import 'package:week7_networking_discussion/models/user_model.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> usersStream = context.watch<UserListProvider>().users;

    return MaterialApp(
      title: "About Me",
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Colors.grey,
        fontFamily: 'Helvetica',
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 20.0),
        ),
      ),
      home: Scaffold(
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            accountName: Text(
              'Cole',
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
              leading: Icon(Icons.today_rounded),
              title: const Text('Todos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              }),
          ListTile(
              leading: Icon(Icons.heat_pump_rounded),
              title: const Text('Friends'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/friends');
              }),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthProvider>().signOut();
              Navigator.pop(context);
            },
          ),
          Divider(),
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
          title: const Text('Profile'),
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
                if (user.userId.toString() ==
                    context.watch<AuthProvider>().userId) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    child: Row(
                      children: [
                        Expanded(
                          /*1*/
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*2*/
                              Container(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  '${user.fname}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                '${user.loc}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*3*/
                        Icon(
                          Icons.cake_rounded,
                          color: Colors.blueGrey,
                        ),
                        Text('${user.bdate}'),
                      ],
                    ),
                  );
                } else {
                  return Text(" ");
                }
              }),
            );
          },
        ),
      ),
    );
  }
}
