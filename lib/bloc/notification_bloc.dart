import 'dart:async';

import 'package:battery_plugin/bloc/notification_events.dart';
import 'package:battery_plugin/bloc/notification_state.dart';
import 'package:battery_plugin/model/notification_model.dart';
import 'package:battery_plugin/model/notification_storage.dart';
import 'package:battery_plugin/src/bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final db = NotificationStorage.instance;

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is FetchNotifications) {
      yield* _mapFetchNotificationEvent(event);
    } else if (event is AddNotification) {
      yield* _mapAddNotificationEvent(event);
    } else if (event is RemoveNotification) {
      yield* _mapRemoveFromCartEventToCartState(event);
    }
  }

  Stream<NotificationState> _mapFetchNotificationEvent(
      FetchNotifications event) async* {
    final notifications = await _fetchNotifications();
    yield NotificationState(
      widgetState: NotificationWidgetState.loaded,
      notifications: notifications,
    );
  }

  Stream<NotificationState> _mapAddNotificationEvent(
      AddNotification event) async* {
    print("IN BLOC TITLE : " + event.notification.id);
    await db.insert(event.notification);
    final notifications = await _fetchNotifications();
    yield NotificationState(
      widgetState: NotificationWidgetState.loaded,
      notifications: notifications,
    );
  }

  Stream<NotificationState> _mapRemoveFromCartEventToCartState(
      RemoveNotification event) async* {
    await db.delete(event.notification);
    final notifications = await _fetchNotifications();
    yield NotificationState(
      widgetState: NotificationWidgetState.loaded,
      notifications: notifications,
    );
  }

  _fetchNotifications() async {
    List<NotificationModel> notifications = [];
    (await db.queryAll()).forEach((element) {
      notifications.add(NotificationModel.fromJson(element));
    });
    print(notifications.toString());
    return notifications;
  }
}
