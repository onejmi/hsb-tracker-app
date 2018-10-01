import 'package:flutter/material.dart';

import 'package:HaltonBusAPI/HaltonBusAPI.dart';

import '../model/filter.dart';

class FilterForm extends StatefulWidget {

  final List<RouteFilter> filters;
  final TextStyle _labelStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
  );

  FilterForm(this.filters);

  @override
  State<StatefulWidget> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String _schoolName = BusAPI().schoolNames[0];
  final routeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: Text("Name", style: widget._labelStyle),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'My Bus',
                    border: OutlineInputBorder()
                  ),
                  controller: nameController,
                  validator: (name) {
                    if(name.isEmpty) {
                      return "Please enter a name";
                    }
                    else if(widget.filters.map((filter) => filter.name).contains(name)) {
                      return "That name is already in use!";
                    }
                  }
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("School", style: widget._labelStyle),
                  DropdownButton<String>(
                      value: _schoolName,
                      onChanged: (name) => setState(() => _schoolName = name),
                      items: BusAPI().schoolNames.map(
                              (schoolName) => DropdownMenuItem<String>(
                            child: SizedBox(
                                width: 150.0,
                                child: Text(schoolName)
                            ),
                            value: schoolName,
                          )
                      ).toList()
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 7.0),
                  child: Text("Route", style: widget._labelStyle),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Route",
                    hintText: "104",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: routeController,
                  validator: (route) {
                    if(int.tryParse(route) == null) {
                      return "Please enter a route number!";
                    }
                  },
                ),
              ],
            ),
            Center(
              child: FlatButton(
                child: Text("ADD"),
                onPressed: () {
                  if(_formKey.currentState.validate()) {
                    //add entry
                    Navigator.pop(context,
                        RouteFilter(nameController.text, school: _schoolName, route: int.tryParse(routeController.text)));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}