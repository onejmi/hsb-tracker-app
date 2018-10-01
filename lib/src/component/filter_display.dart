import 'package:flutter/material.dart';

import '../model/filter.dart';

class FilterDisplay extends StatelessWidget {

  final RouteFilter _filter;
  final void Function(RouteFilter) _onTap;

  FilterDisplay(this._filter, this._onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.0,
      width: 200.0,
      padding: EdgeInsets.all(12.0),
      child: Card(
        child: InkWell(
          onTap: () => _onTap(_filter),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _filter.name,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "School: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                        )
                      ),
                      TextSpan(
                        text: _filter.school,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24.0,
                        )
                      )
                    ]
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "Route: ",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      ),
                      TextSpan(
                        text: _filter.route.toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      )
                    ]
                  )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

}