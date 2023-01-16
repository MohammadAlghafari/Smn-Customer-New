import 'package:smn_delivery_app/data/notifications/api/notifications_api.dart';
import 'package:smn_delivery_app/data/notifications/model/notification.dart';
import 'package:smn_delivery_app/data/notifications/notifications_interface.dart';

class NotificationsRepo implements NotificationsInterface{
  NotificationsApi notificationsApi;

  NotificationsRepo({required this.notificationsApi});
  @override
  Future<List<Notification>> getNotifications() {
    return notificationsApi.getNotifications();
  }

  @override
  Future<Notification> markAsReadNotifications(Notification notification) {
    return notificationsApi.markAsReadNotifications(notification);
  }

  @override
  Future<Notification> removeNotification(Notification cart) {
    return notificationsApi.removeNotification(cart);
  }

  @override
  Future<void> sendNotification(String body, String title, user) {
    return notificationsApi.sendNotification(body, title, user);
  }

}