import 'package:flutter/material.dart';

import 'screen/home.dart';
import 'screen/bus.dart';
import 'screen/call.dart';

import 'model/filter.dart';
import 'model/filter_disk.dart' as data;

import 'server/notification.dart';


class BusApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BusAppState();
}

class _BusAppState extends State<BusApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<RouteFilter> filters = [];

  void readDisk() async {
    await data.diskInit();
    final filtersFromDisk = await data.read();
    setState(() => filters = filtersFromDisk);
  }

  @override
  void initState() {
    super.initState();
    readDisk();
  }

  @override
  Widget build(BuildContext context) {
    NotificationManager().setupReaction(_scaffoldKey);
    return MaterialApp(
        title: 'Halton Bussing',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          cardColor: Colors.orange.shade200,
        ),
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(icon: Icon(Icons.home)),
                    Tab(icon: Icon(Icons.directions_bus)),
                    Tab(icon: Icon(Icons.phone))
                  ],
                ),
                title: Center(
                  child: Text("Halton Buses"),
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  HomePage(filters),
                  BusPage(_scaffoldKey, filters),
                  CallPage(),
                ],
              ),
            )
        )
    );
  }
}
