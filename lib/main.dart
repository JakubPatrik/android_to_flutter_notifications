import 'package:battery_plugin/push_notifications_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:battery_plugin/deeplink_bloc.dart';
import 'package:battery_plugin/deeplink_wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
// This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.instance.start();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Deeplink Notifications',
        home: Scaffold(
            body: Provider<DeepLinkBloc>(
                create: (context) => DeepLinkBloc(),
                dispose: (context, bloc) => bloc.dispose(),
                child: DeepLinkWrapper())));
  }
}
