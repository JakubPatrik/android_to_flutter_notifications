import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('battery_plugin/channel');

  // Future<void> _getBatteryLevel() async {
  //   String batteryLevel;
  //   try {
  //     final int result = await platform.invokeMethod('getBatteryLevel');
  //     batteryLevel = "Battery level at $result %.";
  //   } on PlatformException catch (e) {
  //     batteryLevel = "Failed to get battery level: '${e.message}'.";
  //   }
  //   setState(() {});

  //   return batteryLevel;
  // }

  Future<void> _showNotification() async {
    try {
      final String id = Random().nextInt(10).toString();
      await platform.invokeMethod('showNotification', {
        'title': "Topankovo $id",
        'description': "Nakupte este tento vikend za vyhodne ceny",
        'id': id
      });
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  List<dynamic> l = [" "];

  // Future<void> _readNotifications() async {
  //   try {
  //     var obj = await platform.invokeMethod('readNotification');
  //     print(obj.runtimeType);
  //     setState(() {
  //       l = obj;
  //     });
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> _showNotificationCenter() async {
    try {
      await platform.invokeMethod('showNotificationCenter');
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<void> _subscribeToTopic(String topic) async {
    try {
      await platform.invokeMethod('subscribeToTopic', {"topic": topic});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<void> _unsubscribeFromTopic(String topic) async {
    try {
      await platform.invokeMethod('_unsubscribeFromTopic', {"topic": topic});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  bool _allowNotifications = false;
  bool _pushNotifications = false;
  // bool _canReadNotifications = false;

  final kText = TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Notifikacie",
          style: kText,
        ),
        centerTitle: true,
        leading: Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Color.fromRGBO(234, 235, 237, 0.7),
            height: 40,
          ),
          buildSwitchTile(
              "Povolit notifikacie",
              () => _subscribeToTopic("topic"),
              () => _unsubscribeFromTopic("topic"),
              _allowNotifications),
          Container(
              color: Color.fromRGBO(12, 158, 242, 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 25,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You’ll need to opt in into notification through the Android Settings app to recieve notifications on Topankovo app.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () => _showNotificationCenter(),
                            child: Text("Go to Settings",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff0c9ef2))),
                          ),
                        ],
                      ),
                    )),
                  ])),
          buildSwitchTile("Pushnut notifikaciu", _showNotification,
              _showNotification, _pushNotifications),
          // buildSwitchTile("Ukazat notifikacie", _readNotifications,
          //     _readNotifications, _canReadNotifications),
          Spacer(),
          // Center(
          //     child: FutureBuilder(
          //   future: _getBatteryLevel(),
          //   builder: (context, snapshot) => Text(
          //     snapshot.data ?? "Unknown battery level.",
          //     style: TextStyle(
          //       fontSize: 30,
          //     ),
          //   ),
          // )),
          ...List.generate(l.length, (int index) => Text(l[index])),
        ],
      ),
    );
  }

  Container buildSwitchTile(
      String text, Function fyes, Function fno, bool show) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.label_outline,
            size: 30,
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Text(
            text,
            style: kText,
          )),
          Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              onChanged: (value) async {
                setState(() {
                  if (fyes == _showNotification) {
                    _pushNotifications = value;
                    // } else if (fyes == _readNotifications) {
                    //   _canReadNotifications = value;
                  } else
                    _allowNotifications = value;
                });
                if (value)
                  await fyes.call();
                else
                  await fno.call();
              },
              value: show,
              trackColor: Color(0xffE0E1E3),
              activeColor: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
