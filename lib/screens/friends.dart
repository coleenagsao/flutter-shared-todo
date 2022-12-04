import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

class Friends extends StatelessWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    //Title Section
    Widget titleSection = Container(
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
                  child: const Text(
                    'Friend Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Visit', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            ),
          ),
        ],
      ),
    );

    //Button Section
    Color color = Theme.of(context).primaryColor;

    List hobbies = ["Gaming", "Finance", "Socializing", "Eating", "Reading"];
    List hobbiesIcon = [
      Icons.gamepad,
      Icons.money,
      Icons.call,
      Icons.food_bank,
      Icons.book
    ];

    List<Widget> hobbiesWidget = [];

    for (int i = 0; i < hobbies.length; i++) {
      hobbiesWidget.insert(
          i, _buildButtonColumn(color, hobbiesIcon[i], hobbies[i]));
    }

    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: hobbiesWidget,
    );

    //Text Sectionn
    Widget textSection = const Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do',
        softWrap: true,
      ),
    );

    return MaterialApp(
      title: "Friends",
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
                leading: Icon(Icons.today_rounded),
                title: const Text('Todos'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/');
                }),
            ListTile(
                leading: Icon(Icons.person),
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
            title: const Text('Friends'),
          ),
          body: ListView(
            children: [
              // Image.asset(
              //   'images/bridge.jpg',
              //   width: 600,
              //   height: 240,
              //   fit: BoxFit.cover,
              // ),
              titleSection,
              titleSection,
            ],
          )),
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
