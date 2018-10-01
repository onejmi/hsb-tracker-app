import 'package:flutter/material.dart';

import 'dart:async';

import 'package:HaltonBusAPI/HaltonBusAPI.dart';

import '../component/filter_form.dart';
import '../component/filter_display.dart';
import '../model/filter.dart';
import '../model/filter_disk.dart' as data;

class HomePage extends StatefulWidget {
  final List<RouteFilter> filters;

  HomePage(this.filters);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loaded = false;
  String status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      floatingActionButton: loaded ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          openFilterForm(widget.filters, context).then((filter) {
            if (filter != null) setState(() {
              widget.filters.add(filter);
              data.save(widget.filters);
            });
          });
        },
      ) : CircularProgressIndicator(),
      body: RefreshIndicator(
        onRefresh: refreshStatus,
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.filters.length + 2,
            itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: loaded
                                    ? Text(
                                        status,
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 32.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                }
                else if(index == 1) {
                  if(widget.filters.length > 0) return Divider();
                  else return null;
                }
                else {
                  return FilterDisplay(widget.filters[index - 2], removeFilter);
                }
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (this.mounted) {
      BusAPI().currentStatus().then((status) {
        setState(() {
          loaded = true;
          this.status = status;
        });
      });
    }
  }

  Future<Null> refreshStatus() async {
    final tempStatus = await BusAPI().currentStatus(invalidate: true);
    setState(() => status = tempStatus);
    return null;
  }

  void removeFilter(RouteFilter filter) {
    showDialog<Null>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete ride \"${filter.name}\"?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                setState(() {
                  widget.filters.remove(filter);
                  data.save(widget.filters);
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}

Future<RouteFilter> openFilterForm(
    final List<RouteFilter> filters, BuildContext context) async {
      return await showDialog<RouteFilter>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Add a ride"),
            children: <Widget>[FilterForm(filters)],
          );
        });
}
