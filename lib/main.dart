import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  runApp(DqmMonitorApp());
}

var headings = [Text('SCHOOL NAME'), Text('# OF FILE'), Text('LAST FILE SENT'), Text('LAST ELOG ENTRY'), Text('RATE OF TRIGGERS'), Text('RATE OF TRACKS')];
var values =['SALE-01', '42', 'peppe',  'no', '0', '2'];

var drawer = ['SETTINGS', 'DOCS', 'MONITOR', 'PLOT']; //unused

class AppDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  child: Text(values[0])
              ),
              ListTile(
                  leading: Icon(Icons.video_label),
                  title: Text('MONITOR'),
                  onTap: () {Navigator.pushNamed(context, '/');}
              ), Divider(),
              ListTile(
                  leading: Icon(Icons.scatter_plot),
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

class DqmMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Monitor DQM',
        initialRoute: '/',
        routes: {
          '/': (context) => Monitor(),
          '/settings': (context) => Settings(),
          '/docs': (context) => Docs()
        }
    );
  }
}

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
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  Future<void> onDidRecieveLocalNotification(
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
            title: Text("Select your school"),
            onTap: () {
              //TODO:let a picker assign school_name on a var
            }
          ),
          ListTile(
              title: Text("ELOG reminder"),
              subtitle: Text("Set an alarm which reminds you to check the MRPC"),
              onTap:() async {
                TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                //LOG STUFF
                print(picked.hour);
                print(picked.minute);
                Time scheduledTime = Time(picked.hour, picked.minute, 0);
                _showDailyAtTime(scheduledTime);
              }),
          ListTile(
            title: Text("ELOG Alarm"),
            subtitle: Text("ELOG not taken alarm"),
            onTap: () async {
              //TODO: to implement but needs monitor activity working
              await _showNotification();
            },
          )
        ],
      ),
      drawer: AppDrawer()
  );}

}

class Docs extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return
      DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: "ELOG"),
                Tab(text: "MRPC"),
                Tab(text: "PLOTTING"),
              ],
            ),
          ),
        ),
      );

  }
}

class Monitor extends StatefulWidget{
  _MonitorState createState() => _MonitorState();
}
class _MonitorState extends State<Monitor> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: new AppBar(
          title: new Text("Monitor DQM"),
        ),
        body: new Container(
            child: ListView.separated(

              itemCount: headings.length,
              itemBuilder: (context, index){
                return ListTile(
                    leading: headings[index],
                    title: Text(values[index], textAlign: TextAlign.end)
                );
              },
              separatorBuilder: (context, index){
                return Divider();
              },
            )
        ),
        drawer: AppDrawer()
    );
  }}