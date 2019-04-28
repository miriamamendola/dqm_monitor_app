import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'main.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;

//TODO: setting up something to update the json parsed file
var url = "https://pastebin.com/raw/nPbjH8hM";

//TODO: maybe since it's useful for other classes, I'll move this class in another file
class JSONValues {
  final int id;
  final String telescopeStatus;
  final String schoolName;
  final String filesSent;
  final String lastFileSent;
  final String lastElogEntry;
  final String rateOfTriggers;
  final String rateOfTracks;
  final String dqmLink;

  JSONValues(
      {this.id, this.telescopeStatus, this.schoolName, this.filesSent, this.lastFileSent, this.lastElogEntry, this.rateOfTriggers, this.rateOfTracks, this.dqmLink});

  factory JSONValues.fromJson(Map<String, dynamic> json) {
    return JSONValues(
        id: json['id'],
        telescopeStatus: json['telescope_status'][0],
        schoolName: json['school_name'],
        filesSent: json['files_sent'],
        lastFileSent: json['last_file_sent'],
        lastElogEntry: json['last_elog_entry'],
        rateOfTriggers: json['rate_of_triggers'],
        rateOfTracks: json['rate_of_tracks'],
        dqmLink: json['dqm_link']
    );
  }
}

class Monitor extends StatefulWidget{
  @override
  _MonitorState createState() => _MonitorState();

}

class _MonitorState extends State<Monitor> {
  //final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //new GlobalKey<RefreshIndicatorState>();

  JSONValues values;

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance
    //  .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Monitor DQM"),

        ),
        body: RefreshIndicator(onRefresh: _refresh,
            child: ListView.separated(

              itemCount: headings.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: headings[index],
                    title: Text(monitorValues[index], textAlign: TextAlign.end)
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            )),
        drawer: AppDrawer()
    );
  }

  Future<Null> _refresh() {
    return fetchJSONValues().then((_values) {
      setState(() {
        values = _values;
        _createmonitorvalues(values);
      });
    });
  }

  Future<JSONValues> fetchJSONValues() async {
    final response =
    await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      var jsonFile = json.decode(response.body);
      return JSONValues.fromJson(jsonFile[selectedStation]);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  _createmonitorvalues(JSONValues jsonValues) {
    monitorValues = [];
    monitorValues.add(jsonValues.schoolName);
    monitorValues.add(jsonValues.filesSent);
    monitorValues.add(jsonValues.lastFileSent);
    monitorValues.add(jsonValues.lastElogEntry);
    monitorValues.add(jsonValues.rateOfTriggers);
    monitorValues.add(jsonValues.rateOfTracks);
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