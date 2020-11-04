import 'package:battery_plugin/model/notification_model.dart';

enum NotificationWidgetState {
  idle,
  loading,
  loaded,
  error,
}

class NotificationState {
  final NotificationWidgetState widgetState;
  final List<NotificationModel> notifications;

  const NotificationState({this.widgetState, this.notifications});
}
