import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'filter.dart';

import 'package:path_provider/path_provider.dart';

import '../server/notification.dart';

Directory _diskDir;
File _disk;

Future<void> diskInit() async {
  _diskDir = await getApplicationDocumentsDirectory();
  await _diskDir.create(recursive: true);
  print("Saving data in ${_diskDir.path}");
  _disk = File('${_diskDir.path}/filters.json');
  bool exists = await _disk.exists();
  if(!exists) await _disk.create(recursive: true);
}

Future<void> save(List<RouteFilter> filters) async {
  NotificationManager().filters = filters;
  await _disk.writeAsString(jsonEncode(filters));
}

Future<List<RouteFilter>> read() async {
  try {
    _disk = File('${_diskDir.path}/filters.json');
    var raw = jsonDecode(await _disk.readAsString());
    List<RouteFilter> filters = [];
    for(var jsonFilter in raw) {
      filters.add(RouteFilter.fromJson(jsonFilter));
    }
    return filters;
  }
  catch (e) {
    return [];
  }

}

