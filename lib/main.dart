import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('battery_plugin/channel');

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = "Battery level at $result %.";
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {});

    return batteryLevel;
  }

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

  Future<void> _readNotifications() async {
    try {
      var obj = await platform.invokeMethod('readNotification');
      print(obj.toString());
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  Future<void> _showNotificationCenter() async {
    try {
      await platform.invokeMethod('showNotificationCenter');
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Battery LEVEL INFO"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
              child: FutureBuilder(
            future: _getBatteryLevel(),
            builder: (context, snapshot) => Text(
              snapshot.data ?? "Unknown battery level.",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          )),
          FlatButton.icon(
            icon: Icon(Icons.notifications),
            onPressed: () => _showNotification(),
            label: Text("Show Notification"),
          ),
          FlatButton.icon(
            icon: Icon(Icons.notifications),
            onPressed: () => _readNotifications(),
            label: Text("Display Notification"),
          ),
          FlatButton.icon(
            icon: Icon(Icons.notifications),
            onPressed: () => _showNotificationCenter(),
            label: Text("Notification Center"),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.battery_std,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () => _getBatteryLevel(),
      ),
    );
  }
}
