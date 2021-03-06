import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'drawer.dart';
import 'main.dart';

class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  var platform = MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  initState() {
    super.initState();
  }

  Future onSelectNotification(String payload) async {
    return null;
  }
  @override
  Widget build(BuildContext context) {return Scaffold(
      appBar: new AppBar(
        title: new Text("SETTINGS"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              title: Text("Select EEE station"),
              onTap: () {Navigator.pushNamed(context, '/eeeactivestations');}

          ), Divider()
        ],
      ),
      drawer: AppDrawer()
  );}

}
class EEEActiveStations extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          title: Text("EEE ACTIVE STATIONS"),
        ),
        body: new Container(
            child: ListView.separated(

              itemCount: EEE_ACTIVE_STATIONS.length,
              itemBuilder: (context, index){
                return ListTile(
                    title: Text(EEE_ACTIVE_STATIONS[index]),
                    onTap: () async {
                      selectedStation = index;
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setInt('selectedStation', selectedStation);
                      Navigator.pop(context);
                    }
                );
              },
              separatorBuilder: (context, index){
                return Divider();
              },
            )
        )
    );
  }
}