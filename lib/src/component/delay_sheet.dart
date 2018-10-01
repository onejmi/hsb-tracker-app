import 'package:flutter/material.dart';

import 'package:HaltonBusAPI/HaltonBusAPI.dart';

class DelaySheet extends StatelessWidget {

  final Delay _delay;

  DelaySheet(this._delay);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrangeAccent,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
                "Route ${_delay.route}",
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                textBaseline: TextBaseline.ideographic
              ),
            ),
          ),
          infoTag(context, "Delay: ", _delay.status),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: infoTag(context, "School(s): ", _delay.schools.reduce((first, second) => "$first, $second")),
          ),
          infoTag(context, "Reported: ", _delay.time.toIso8601String()),
        ],
      )
    );
  }
}

RichText infoTag(BuildContext context, String key, String value) {
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: key,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          )
        ),
        TextSpan(
          text: value,
          style: TextStyle(
            fontSize: 24.0,
            color: Theme.of(context).primaryColorLight,
          )
        )
      ]
    ),
  );
}