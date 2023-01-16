import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/myColors.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/injectionContaner.dart' as di;
import 'package:smn_delivery_app/view_models/home_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';



class SplashScreen extends StatefulWidget {
  
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  startTime() async {
    var _duration = const Duration(milliseconds: 4000);
    return Timer(_duration, navigationPage);
  }


  void navigationPage() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // if (prefs.getString("language_code") == null) {
    // //   prefs.setString("language_code", "en");
    // // }
    // // Provider.of<AppLanguage>(context, listen: false)
    // //     .changeLanguage(Locale(prefs.getString("language_code")??"en"));
    // // prefs.clear();
    //
    // // Navigator.pushReplacementNamed(context, 'HomeScreen',arguments: 2);
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        Provider.of<SettingViewModel>(context,listen: false).loadSettings();
        Provider.of<HomeViewModel>(context,listen: false).refreshHome();
        Navigator.pushNamedAndRemoveUntil(
            context, 'HomeScreen', (route) => false,
            arguments: {'initialPage':2});
      }
    } on SocketException catch (_) {
      print('not connected');
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.verify_your_internet_connection,
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: myColors.deepOrange,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 12.0
      );
      // Navigator.pushReplacementNamed(
      //     context, '/',);
      Timer(Duration(milliseconds: 4000), navigationPage);
    }

  }


  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/img/logo_animation.gif",
                  width: width / 3,
                ),
              ],
            ),
          ),
        ));
  }
}
