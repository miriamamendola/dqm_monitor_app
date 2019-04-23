import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main() {flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
runApp(DqmMonitorApp());}

var headings = [Text('SCHOOL NAME'), Text('# OF FILE'), Text('LAST FILE SENT'), Text('LAST ELOG ENTRY'), Text('RATE OF TRIGGERS'), Text('RATE OF TRACKS')];
var values =['SALE-01', '42', 'peppe',  'no', '0', '2'];

var drawer = ['SETTINGS', 'DOCS', 'MONITOR', 'PLOT']; //unused

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
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

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {return Scaffold(
      appBar: new AppBar(
        title: new Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
              title: Text("ELOG reminder"),
              subtitle: Text("Set an alarm which reminds you to check the MRPC"),
              onTap:() async {
                TimeOfDay picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                print(picked.hour);
                print(picked.minute);
              }),
          ListTile(
            title: Text("ELOG Alarm"),
            subtitle: Text("Quanto tempo dopo va avvisato?"),
            onTap: () async {
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

class Monitor extends StatelessWidget {
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