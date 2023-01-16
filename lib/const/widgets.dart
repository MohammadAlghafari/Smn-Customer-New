import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../smn_customer.dart';

void showToast(
    {ToastGravity gravity = ToastGravity.BOTTOM,
    Color? textColor,
    Color? backgroundColor,
    required BuildContext context,
    required String message}) {

  FToast fToast;
  fToast = FToast();
  fToast.init(context);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      // border: Border.all(
      //     color: Theme.of(NavigationService.navigatorKey.currentContext!)
      //         .accentColor,
      //     width: 2),
      color:Theme.of(context).brightness==Brightness.light? Colors.grey[200]:Colors.grey[800],
    ),
    child: Text(
      message,
      style: TextStyle(color:Theme.of(context).brightness==Brightness.light? Colors.black:Colors.white,fontSize: 12),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.BOTTOM,
    toastDuration: Duration(seconds: 2),
  );
}

buildShowDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).accentColor,
          ),
        );
      });
}

Widget buildProgressIndicator(bool show) {
  return new Padding(
    padding: const EdgeInsets.all(15.0),
    child: new Center(
      child: new Opacity(
        opacity: show ? 1.0 : 00,
        child: new CircularProgressIndicator(),
      ),
    ),
  );
}

launchURL(String url) async {
  String _uri = Uri.encodeFull(url);
  if (await canLaunch(_uri)) {
    await launch(_uri);
  } else {
    throw 'Could not launch $url';
  }
}

showSnackBar(
    {required String message, Color? backgroundColor, Color? textColor}) {
  ScaffoldMessenger.of(NavigationService.navigatorKey.currentContext!)
      .showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: textColor),
    ),
    backgroundColor: backgroundColor,
  ));
}
