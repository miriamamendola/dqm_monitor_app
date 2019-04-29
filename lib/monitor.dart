import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'main.dart';
import 'drawer.dart';
import 'package:http/http.dart' as http;

import 'package:html/parser.dart' show parse;

//TODO: setting up something to update the json parsed file
const url = 'https://iatw.cnaf.infn.it/eee/monitor/';
var document;


//TODO: maybe since it's useful for other classes, I'll move this class in another file
class MonitorData {
  final String schoolName;
  final String filesSent;
  final String lastFileSent;
  final String lastElogEntry;
  final String rateOfTriggers;
  final String rateOfTracks;
  final String telescopeStatus;


  MonitorData(
      {this.schoolName, this.filesSent, this.lastFileSent, this.lastElogEntry, this.rateOfTriggers, this.rateOfTracks, this.telescopeStatus});

//qui metto il parser
  factory MonitorData.parseHTML(String str) {
    print(url);
    final document = parse(str);
    final table = document.body
        .getElementsByTagName("table")
        .first;
    final tableRow = table.getElementsByTagName("tr")[selectedStation +
        1]; //element

    return MonitorData(
        schoolName: tableRow.children[0].children[0].text,
        //element
        filesSent: tableRow.children[4].text.split("[")[0],
        lastFileSent: tableRow.children[3].text,
        lastElogEntry: tableRow.children[5].text,
        rateOfTriggers: tableRow.children[8].text,
        rateOfTracks: tableRow.children[9].text
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
            title: new Text("Monitor DQM"),

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
      return CircularProgressIndicator();
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