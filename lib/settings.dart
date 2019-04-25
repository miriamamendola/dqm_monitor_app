import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'drawer.dart';


class Settings extends StatefulWidget{
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  var platform = MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok')
          )
        ],
      ),
    );
  }
  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
  Future<void> _showDailyAtTime(Time scheduledTime) async {
    var time = scheduledTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'ELOG REMINDER',
        'Daily notification shown at approximately ${(time.hour)}:${(time.minute)}:${(time.second)}',
        time,
        platformChannelSpecifics);
  }

  Future onSelectNotification(String payload) async {
    return null;
  }
  @override
  Widget build(BuildContext context) {return Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              title: Text("Select EEE station"),
              onTap: () {Navigator.pushNamed(context, '/eeeactivestations');}

          ), Divider(),
          ListTile(
              title: Text("ELOG reminder"),
              subtitle: Text("Set an alarm, once a day, which reminds you to check the MRPC."),
              onTap:() async {
                TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                //LOG STUFF
                print(picked.hour);
                print(picked.minute);
                Time scheduledTime = Time(picked.hour, picked.minute, 0);
                _showDailyAtTime(scheduledTime);
              }), Divider(),
          ListTile(
            title: Text("ELOG Alarm"),
            subtitle: Text(""),
            onTap: () async {
              //TODO: to implement but needs monitor activity working + snackbar!
              await _showNotification();
            },
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
          title: Text("Settings"),
        ),
        body: new Container(
            child: ListView.separated(

              itemCount: EEE_ACTIVE_STATIONS.length,
              itemBuilder: (context, index){
                return ListTile(
                    title: Text(EEE_ACTIVE_STATIONS[index]),
                    onTap: (){
                      //TODO:this method assign the station
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