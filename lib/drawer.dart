import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';


class AppDrawer extends StatefulWidget {
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var background;

  @override
  Widget build(BuildContext context){
    if (telescope.status == "green") {
      background = Colors.green;
    } else if (telescope.status == "yellow") {
      background = Colors.yellow;
    } else if (telescope.status == "red") {
      background = Colors.red;
    } else {
      background = Colors.grey;
    }
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                    backgroundColor: background),
                accountName: Text(EEE_ACTIVE_STATIONS[selectedStation]),
                accountEmail: null,
              ),
              ListTile(
                  leading: Icon(Icons.home),
                  title: Text('HOME'),
                  onTap: () {
                    Navigator.pushNamed(context, '/');
                  }
              ), Divider(),
              ListTile(
                  leading: Icon(Icons.desktop_mac),
                  title: Text('MONITOR'),
                  onTap: () {
                    Navigator.pushNamed(context, '/monitor');
                  }
              ), Divider(),
              ListTile(
                  leading: Icon(Icons.show_chart),
                  title: Text('PLOT')
              ), Divider(),
              ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('SETTINGS'),
                  onTap: () {Navigator.pushNamed(context, '/settings');}
              ), Divider(),
              ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text('DOCS'),
                  onTap: () {Navigator.pushNamed(context, '/docs');}
              ), Divider()
            ]
        )
    );
  }

}