import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/notifications/model/notification.dart' as model;
import 'package:smn_delivery_app/data/notifications/notifications_repo.dart';
import 'package:smn_delivery_app/smn_customer.dart';


class NotificationsViewModel extends ChangeNotifier {
  NotificationsRepo notificationsRepo;
  List<model.Notification> notifications = <model.Notification>[];
  int unReadNotificationsCount = 0;

  NotificationsViewModel({required this.notificationsRepo}) {
    listenForNotifications();
  }

  sendNotification(String body, String title, user) {
    return notificationsRepo.sendNotification(body, title, user);
  }

  void listenForNotifications({String? message}) async {
    notifications = await notificationsRepo.getNotifications();
    if (notifications.isNotEmpty) {
      unReadNotificationsCount = notifications
          .where((model.Notification _n) => !_n.read)
          .where((element) => element.createdAt != DateTime(0))
          .toList()
          .length;
    } else {
      unReadNotificationsCount = 0;
    }
    notifyListeners();
  }

  Future<void> refreshNotifications() async {
    notifications.clear();
    listenForNotifications(
        message:
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                .notifications_refreshed_successfuly);
  }

  void doMarkAsReadNotifications(model.Notification _notification) async {
    notificationsRepo.markAsReadNotifications(_notification).then((value) {
      --unReadNotificationsCount;
      _notification.read = !_notification.read;
      notifyListeners();
      showSnackBar(
        message:
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                .thisNotificationHasMarkedAsRead,
      );
    });
  }

  void doMarkAsUnReadNotifications(model.Notification _notification) {
    notificationsRepo.markAsReadNotifications(_notification).then((value) {
      ++unReadNotificationsCount;
      _notification.read = !_notification.read;
      notifyListeners();

      showSnackBar(
        message:
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                .thisNotificationHasMarkedAsUnread,
      );
    });
  }

  void doRemoveNotification(model.Notification _notification) async {
    notificationsRepo.removeNotification(_notification).then((value) {
      if (!_notification.read) {
        --unReadNotificationsCount;
      }
      notifications.remove(_notification);
      notifyListeners();

      showSnackBar(
          message: AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .notificationWasRemoved);
    });
  }
}
