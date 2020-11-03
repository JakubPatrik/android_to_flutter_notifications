import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  final BuildContext context;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  PushNotificationService(this.context);

  void initialise() {
    if (Platform.isIOS) {
      // request permissions if we're on iOS
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      // Called when the app is in the foreground and we receive a push notification
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _serialiseAndNavigate(message);
      },
      // Called when the app has been closed comlpetely and it's opened
      // from the push notification.
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _serialiseAndNavigate(message);
      },
      // Called when the app is in the background and it's opened
      // from the push notification.
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _serialiseAndNavigate(message);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Container(
                  color: Colors.red,
                  child: Text(
                    notificationData.toString() ?? "null",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ))));
    print(notificationData.toString());
  }
}
