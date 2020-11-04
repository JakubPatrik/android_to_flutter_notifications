import 'dart:async';

import 'package:battery_plugin/bloc/notification_bloc.dart';
import 'package:battery_plugin/bloc/notification_events.dart';
import 'package:battery_plugin/model/notification_model.dart';
import 'package:battery_plugin/src/bloc_provider.dart';
import 'package:flutter/material.dart';

class Helper {
  Helper({this.context}) {
    _notificationStreamController.onListen = _onListen;
  }

  bool _sendBufferedEvents = true;
  final BuildContext context;

  Map<String, dynamic> _bufferedEvent;

  Stream<NotificationModel> get notificationStream =>
      _notificationStreamController.stream;

  final _notificationStreamController =
      StreamController<NotificationModel>.broadcast();

  /// Called when `_notificationStreamController` gets first subscriber.
  ///
  /// We need to do this for onLaunch Notification.
  ///
  /// When we click the notification (when app is completely closed) `_notificationStreamController` will add event before it gets any subscriber.
  ///
  /// So we will cache the event before it gets first subscriber.
  ///
  /// In other scenario `_notificationStreamController` will have atleast one subscriber.
  _onListen() {
    if (_sendBufferedEvents) {
      if (_bufferedEvent != null) {
        _notificationStreamController.sink
            .add(NotificationModel.fromJson(_bufferedEvent));
      }
      _sendBufferedEvents = false;
    }
  }

  void newNotification(Map<String, dynamic> notification) {
    NotificationModel n = NotificationModel.fromJson(notification);
    if (_sendBufferedEvents) {
      _bufferedEvent = notification;
    } else {
      _notificationStreamController.sink.add(n);
    }
    print("new notification ");
    BlocProvider.of<NotificationBloc>(context)
        .add(AddNotification(notification: n));
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
