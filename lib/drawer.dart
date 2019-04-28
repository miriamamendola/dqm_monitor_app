import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';

class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(),
                accountName: Text(EEE_ACTIVE_STATIONS[selectedStation]),
                accountEmail: null,
                  //TODO: make avatar show the status of the chosen MRPC
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
    );}}