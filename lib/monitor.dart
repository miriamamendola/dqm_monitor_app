import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'main.dart';
import 'drawer.dart';

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