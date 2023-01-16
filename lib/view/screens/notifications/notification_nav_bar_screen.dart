import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/notifications/model/notification.dart'
    as not;
import 'package:smn_delivery_app/view/customWidget/PermissionDeniedWidget.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view/screens/notifications/widget/empty_notifications_widget.dart';
import 'package:smn_delivery_app/view/screens/notifications/widget/notification_item_widget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/notifications_view_model.dart';

class NotificationNavBarScreen extends StatefulWidget {
  const NotificationNavBarScreen({Key? key}) : super(key: key);

  @override
  _NotificationNavBarScreenState createState() =>
      _NotificationNavBarScreenState();
}

class _NotificationNavBarScreenState extends State<NotificationNavBarScreen> {
  List<not.Notification> notifications = [];
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      key: scaffoldKey,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        leading: IconButton(
          tooltip: _trans.menu,
          icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.notifications,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: Consumer2<AuthViewModel, NotificationsViewModel>(
        builder: (context, authModel, notifyModel, child) {
          return authModel.user == null
              ? PermissionDeniedWidget()
              : RefreshIndicator(
                  onRefresh: notifyModel.refreshNotifications,
                  child: notifyModel.notifications
                          .where((element) => element.createdAt != DateTime(0))
                          .toList()
                          .isEmpty
                      ? EmptyNotificationsWidget()
                      : ListView(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 10),
                              child: ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                leading: Icon(
                                  Icons.notifications,
                                  color: Theme.of(context).hintColor,
                                ),
                                title: Text(
                                  _trans.notifications,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                subtitle: Text(
                                  _trans
                                      .swipeLeftTheNotificationToDeleteOrReadUnreadIt,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ),
                            ListView.separated(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: notifyModel.notifications
                                  .where((element) =>
                                      element.createdAt != DateTime(0))
                                  .toList()
                                  .length,
                              separatorBuilder: (context, index) {
                                return SizedBox(height: 15);
                              },
                              itemBuilder: (context, index) {
                                return NotificationItemWidget(
                                  notification: notifyModel.notifications
                                      .where((element) =>
                                          element.createdAt != DateTime(0))
                                      .toList()
                                      .elementAt(index),
                                  onMarkAsRead: () {
                                    notifyModel.doMarkAsReadNotifications(
                                        notifyModel.notifications
                                            .toList()
                                            .elementAt(index));
                                  },
                                  onMarkAsUnRead: () {
                                    notifyModel.doMarkAsUnReadNotifications(
                                        notifyModel.notifications
                                            .toList()
                                            .elementAt(index));
                                  },
                                  onRemoved: () {
                                    notifyModel.doRemoveNotification(notifyModel
                                        .notifications
                                        .toList()
                                        .elementAt(index));
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                );
        },
      ),
    );
  }
}
