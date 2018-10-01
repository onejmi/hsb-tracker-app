import 'package:flutter/material.dart';

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:HaltonBusAPI/HaltonBusAPI.dart';

import '../component/delay_sheet.dart';
import '../screen/bus.dart';
import '../model/filter.dart';

class NotificationManager {

  static final manager = NotificationManager._internal();

  FirebaseMessaging _firebaseMessaging;
  List<Delay> delays;
  List<RouteFilter> filters;
  GlobalKey<ScaffoldState> scaffoldKey;

  factory NotificationManager() {
    return manager;
  }

  NotificationManager._internal() {
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.requestNotificationPermissions();
  }

  void setupReaction(GlobalKey<ScaffoldState> key) {
    scaffoldKey = key;
    _firebaseMessaging.configure(
      onMessage: _openDelay,
      onLaunch: _openDelay,
      onResume: _openDelay,
    );
  }

  void debugDevice() {
    _firebaseMessaging.getToken().then((token) => print(token));
  }

  //TODO finish notifications when cloud server is accessible
  Future<void> _openDelay(Map<String, dynamic> message) async {
    delays = filter(filters, await BusAPI().latest());
    if(message['route'] != null) {
      scaffoldKey.currentState.showBottomSheet(
              (context) =>
              DelaySheet(delays
                  .where((delay) =>
              delay.route.toString() == message['route']).first)
      );
    }
  }
}