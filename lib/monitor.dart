import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';
import 'main.dart';
import "parser.dart";

class Monitor extends StatefulWidget{
  @override
  _MonitorState createState() => _MonitorState();

}

class _MonitorState extends State<Monitor> {
  //final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //new GlobalKey<RefreshIndicatorState>();

  MonitorData values;

  @override
  void initState() {
    super.initState();

    //WidgetsBinding.instance
    //  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
          appBar: new AppBar(
            title: new Text("MONITOR DQM"),

          ),
          body: RefreshIndicator(onRefresh: _refresh,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: headings[0],
                    title: Text(values.schoolName, textAlign: TextAlign.end),
                  ), Divider(),
                  ListTile(
                    leading: headings[1],
                    title: Text(values.filesSent, textAlign: TextAlign.end),
                  ), Divider(),
                  ListTile(
                    leading: headings[2],
                    title: Text(values.lastFileSent, textAlign: TextAlign.end),
                  ), Divider(),
                  ListTile(
                    leading: headings[3],
                    title: Text(values.lastElogEntry, textAlign: TextAlign.end),
                  ), Divider(),
                  ListTile(
                    leading: headings[4],
                    title: Text(values.rateOfTracks, textAlign: TextAlign.end),
                  ), Divider(),
                  ListTile(
                    leading: headings[5],
                    title: Text(
                        values.rateOfTriggers, textAlign: TextAlign.end),
                  ), Divider(),
                ],
              )
          ),
          drawer: AppDrawer()

      );
    } catch (e) {
      return new Container(
          child: SizedBox(child: const CircularProgressIndicator(),
              width: 200,
              height: 200
          )

      );
    }

  }

  Future<Null> _refresh() {
    return fetchMonitorData().then((_values) {
      setState(() {
        values = _values;
      });
    });
  }

  Future<MonitorData> fetchMonitorData() async
  {
    final response =
    await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return MonitorData.parseHTML(response.body);

    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }


}


/*FutureBuilder<JSONValues>(
        future: values,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            monitorValues.add(snapshot.data.schoolName);
            monitorValues.add(snapshot.data.filesSent);
            monitorValues.add(snapshot.data.lastFileSent);
            monitorValues.add(snapshot.data.lastElogEntry);
            monitorValues.add(snapshot.data.rateOfTriggers);
            monitorValues.add(snapshot.data.rateOfTracks);
            else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        } );*/