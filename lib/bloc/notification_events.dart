import 'package:battery_plugin/model/notification_model.dart';

abstract class NotificationEvent {
  const NotificationEvent();
}

class FetchNotifications extends NotificationEvent {}

class AddNotification extends NotificationEvent {
  final NotificationModel notification;

  const AddNotification({this.notification});
}

class RemoveNotification extends NotificationEvent {
  final NotificationModel notification;

  const RemoveNotification({this.notification});
}
