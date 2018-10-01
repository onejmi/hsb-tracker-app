import 'package:flutter/material.dart';

import 'dart:async';

import 'package:HaltonBusAPI/HaltonBusAPI.dart';

import '../component/delay_sheet.dart';
import '../model/filter.dart';
import '../server/notification.dart';

class BusPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey;
  final List<RouteFilter> filters;

  BusPage(this._scaffoldKey, this.filters);

  @override
  State<BusPage> createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  bool isLoaded = false;
  List<Delay> delays = [];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshDelays,
      child: Container(
        color: Theme.of(context).primaryColorDark,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: isLoaded
                ? delays.length > 0 ? ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: delays.length,
                    itemBuilder: (context, index) =>
                        BusCard(delays[index], widget._scaffoldKey),
                  )
            : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      "No delays have been reported =)",
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ]
            )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    NotificationManager().delays = delays;
    BusAPI().latest().then((completedDelays) {
      if (this.mounted) {
        setState(() {
          delays = filter(widget.filters, completedDelays);
          isLoaded = true;
        });
      }
    });
  }

  Future<Null> refreshDelays() async {
    final asyncDelays = await BusAPI().latest(invalidate: true);
    setState(() => delays = filter(widget.filters, asyncDelays));
    return null;
  }
}

class BusCard extends StatelessWidget {
  final Delay _delay;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  const BusCard(this._delay, this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          openDelay();
        },
        splashColor: Theme.of(context).primaryColorDark,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "Route ${_delay.route}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          getTimeSince(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  children: <Widget>[
                    Text(_delay.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openDelay() {
    _scaffoldKey.currentState.showBottomSheet((context) => DelaySheet(_delay));
  }

  String getTimeSince() {
    final timezoneOffset = 60000 * 60 * 4;
    final timePosted = _delay.time.millisecondsSinceEpoch -
        timezoneOffset +
        (_delay.time.hour < 1 ? 60000 * 60 * 12 : 0);
    final now = DateTime.now().millisecondsSinceEpoch;
    final differenceInMinutes = ((now - timePosted) ~/ 60000);
    final hours = (differenceInMinutes / 60).floor();
    return "${hours > 0 ? " $hours hour(s) and" : ""}"
        " ${differenceInMinutes - (60 * hours)} minute(s) ago";
  }
}
