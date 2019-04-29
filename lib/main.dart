import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'docs.dart';
import 'monitor.dart';
import 'settings.dart';
import 'drawer.dart';

void main() async {
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  runApp(DqmMonitorApp());
}

const EEE_ACTIVE_STATIONS = [
  'ALTA-01',
  'ANCO-01',
  'AREZ-01',
  'BARI-01',
  'BOLO-01',
  'BOLO-02',
  'BOLO-03',
  'BOLO-04',
  'BOLO-05',
  'CAGL-01',
  'CAGL-02',
  'CAGL-03',
  'CAGL-04',
  'CARI-01',
  'CATA-01',
  'CATA-02',
  'CATZ-01',
  'CERN-01',
  'CERN-02',
  'COSE-01',
  'FRAS-01',
  'FRAS-02',
  'FRAS-03',
  'GENO-01',
  'GROS-01',
  'GROS-02',
  'LAQU-01',
  'LAQU-02',
  'LECC-01',
  'LECC-02',
  'LODI-01',
  'LODI-02',
  'LODI-03',
  'PARM-01',
  'PATE-01',
  'PISA-01',
  'POLA-01',
  'POLA-02',
  'POLA-03',
  'POLA-04',
  'REGG-01',
  'REND-01',
  'ROMA-01',
  'ROMA-02',
  'SALE-01',
  'SALE-02',
  'SAVO-01',
  'SAVO-02',
  'SAVO-03',
  'SIEN-01',
  'SIEN-02',
  'TERA-01',
  'TORI-01',
  'TORI-02',
  'TORI-03',
  'TORI-04',
  'TRAP-01',
  'TREV-01',
  'TRIN-01',
  'VIAR-01',
  'VIAR-02',
  'VICE-01'
];

const drawer = ['SETTINGS', 'DOCS', 'MONITOR', 'PLOT']; //unused drawer links
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

const headings = [
  Text('SCHOOL NAME'),
  Text('# OF FILE'),
  Text('LAST FILE SENT'),
  Text('LAST ELOG ENTRY'),
  Text('RATE OF TRIGGERS'),
  Text('RATE OF TRACKS')
];

var selectedStation = 0;


//TODO: implement refresh in Home()
var imgUrl = 'https://iatw.cnaf.infn.it/eee/monitor/dqm2/datatransfer/eventdisplay/' +
    EEE_ACTIVE_STATIONS[selectedStation] + 'last.gif';

class DqmMonitorApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Monitor DQM', initialRoute: '/', routes: {
      '/monitor': (context) => Monitor(),
      '/settings': (context) => Settings(),
      '/docs': (context) => Docs(),
      '/eeeactivestations': (context) => EEEActiveStations(),
      '/': (context) => Home()
    });
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  _loadSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedStation = (prefs.getInt('selectedStation') ?? 0);
  }

  @override
  void initState() {
    super.initState();
    _loadSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
          appBar: new AppBar(
            title: new Text(EEE_ACTIVE_STATIONS[selectedStation]),

          ),
          body: Center(
            child: Column(
                children: <Widget>[
                  Text(EEE_ACTIVE_STATIONS[selectedStation] + " seems to work"),
                  Text("enjoy a gif"),
                  Image.network(imgUrl)
                ]),
          ),

          drawer: AppDrawer()
      );
    } catch (e) {
      return CircularProgressIndicator();
    }
  }


}

