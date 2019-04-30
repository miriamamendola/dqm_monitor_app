import 'package:html/parser.dart' show parse;

import 'main.dart';

const url = 'https://iatw.cnaf.infn.it/eee/monitor/';
var document;

class MonitorData {
  final String schoolName;
  final String filesSent;
  final String lastFileSent;
  final String lastElogEntry;
  final String rateOfTriggers;
  final String rateOfTracks;
  final String telescopeStatus;

  MonitorData(
      {this.schoolName,
      this.filesSent,
      this.lastFileSent,
      this.lastElogEntry,
      this.rateOfTriggers,
      this.rateOfTracks,
      this.telescopeStatus});

  factory MonitorData.parseHTML(String str) {
    print(url);
    final document = parse(str);
    final table = document.body.getElementsByTagName("table").first;
    final tableRow =
        table.getElementsByTagName("tr")[selectedStation + 1]; //element

    return MonitorData(
        schoolName: tableRow.children[0].children[0].text,
        filesSent: tableRow.children[4].text.split("[")[0],
        lastFileSent: tableRow.children[3].text,
        lastElogEntry: tableRow.children[5].text.substring(0, 5) +
            " " +
            tableRow.children[5].text.substring(5),
        rateOfTriggers: tableRow.children[8].text,
        rateOfTracks: tableRow.children[9].text);
  }
}

class TelescopeStatus {
  final status;

  TelescopeStatus({this.status});

  factory TelescopeStatus.getStatus(String str) {
    print(url);
    final document = parse(str);
    final table = document.body.getElementsByTagName("table").first;
    final tableRow =
        table.getElementsByTagName("tr")[selectedStation + 1]; //element
    print(tableRow.attributes["class"]);
    return TelescopeStatus(status: tableRow.attributes["class"]);
  }
}
