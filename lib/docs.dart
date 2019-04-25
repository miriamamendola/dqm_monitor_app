import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'drawer.dart';


class Docs extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return
      DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: AppDrawer(),
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