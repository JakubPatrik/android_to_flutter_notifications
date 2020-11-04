import 'package:battery_plugin/bloc/notification_bloc.dart';
import 'package:battery_plugin/bloc/notification_events.dart';
import 'package:battery_plugin/src/bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:battery_plugin/bloc/deeplink_bloc.dart';
import 'package:battery_plugin/widgets/deeplink_wrapper.dart';
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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Deeplink Notifications',
      home: Scaffold(
        body: MultiProvider(
          providers: [
            Provider<DeepLinkBloc>(
              create: (context) => DeepLinkBloc(),
              dispose: (context, bloc) => bloc.dispose(),
            ),
            BlocProvider<NotificationBloc>(
              create: (context) {
                final bloc = NotificationBloc();
                bloc.add(FetchNotifications());
                return bloc;
              },
            ),
          ],
          child: DeepLinkWrapper(),
        ),
      ),
    );
  }
}
