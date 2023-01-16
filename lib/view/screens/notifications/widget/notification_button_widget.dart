import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view_models/notifications_view_model.dart';

class NotificationButtonWidget extends StatefulWidget {
  final Color iconColor;
  final Color labelColor;
  const NotificationButtonWidget({Key? key, required this.iconColor, required this.labelColor}) : super(key: key);

  @override
  _NotificationButtonWidgetState createState() => _NotificationButtonWidgetState();
}

class _NotificationButtonWidgetState extends State<NotificationButtonWidget> {

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).pushNamed('NotificationsScreen');
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: <Widget>[
          Icon(
            Icons.notifications_none,
            color: widget.iconColor,
            size: 28,
          ),
          Container(
            child: Consumer<NotificationsViewModel>(builder: (context, notificationsModel, child) {
              return Text(
                notificationsModel.unReadNotificationsCount.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption!.merge(
                  TextStyle(color: Theme.of(context).primaryColor, fontSize: 8, height: 1.3),
                ),
              );
            },),
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(color: this.widget.labelColor, borderRadius: BorderRadius.all(Radius.circular(10))),
            constraints: BoxConstraints(minWidth: 13, maxWidth: 13, minHeight: 13, maxHeight: 13),
          ),
        ],
      ),
      color: Colors.transparent,
    );
  }
}
