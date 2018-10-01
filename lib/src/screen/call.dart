import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class CallPage extends StatelessWidget {

  final haltonBusNumber = "9056374009";

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      color: Theme.of(context).cardColor,
      child: ButtonTheme(
        minWidth: 300.0,
        height: 65.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
          child: RaisedButton(
            color: Theme.of(context).primaryColorDark,
            child: Container(
              width: 200.0,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 0.0),
                    child: Text(
                      "Call Halton Buses",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  Icon(Icons.phone),
                ],
              ),
            ),
            onPressed: call,
          ),
        ),
      ),
    );
  }

  void call() async {
    if(await urlLauncher.canLaunch("tel://$haltonBusNumber")) {
      await urlLauncher.launch("tel://$haltonBusNumber");
    }
    else {
      print("Failed to call halton busses");
    }
  }
}
