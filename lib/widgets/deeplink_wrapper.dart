import 'package:battery_plugin/bloc/deeplink_bloc.dart';
import 'package:battery_plugin/widgets/notification_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeepLinkWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<DeepLinkBloc>(context);

    return StreamBuilder<String>(
        stream: _bloc.state,
        builder: (context, snapshot) {
          // if app is started normally, no deep link is clicked show your old home page widget
          if (!snapshot.hasData) {
            return NotificationView();
          } else {
            return Scaffold(
              key: UniqueKey(),
              body: Center(
                  child: Text(
                snapshot.data,
                style: TextStyle(fontSize: 24, color: Colors.blue),
              )),
            );
          }
        });
  }
}