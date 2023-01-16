import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../generated/l10n.dart';
import 'package:smn_delivery_app/utili/app_config.dart' as config;

class EmptyAddressesWidget extends StatefulWidget {
  EmptyAddressesWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EmptyAddressesWidgetState createState() => _EmptyAddressesWidgetState();
}

class _EmptyAddressesWidgetState extends State<EmptyAddressesWidget> {
  bool loading = true;
  late AppLocalizations _trans;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            backgroundColor: Theme.of(context).accentColor.withOpacity(0.2),
            color: Theme.of(context).accentColor,
          ),
        )
            : SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: config.App().appHeight(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Opacity(
                opacity: 0.4,
                child: Text(
                  _trans.there_is_no_addresses,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3!.merge(TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              SizedBox(height: 20),
              // !loading
              //     ? FlatButton(
              //   onPressed: () {
              //     Navigator.of(context).pushNamed('/Pages', arguments: 2);
              //   },
              //   padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
              //   color: Theme.of(context).accentColor.withOpacity(1),
              //   shape: StadiumBorder(),
              //   child: Text(
              //     _trans.start_exploring,
              //     style: Theme.of(context).textTheme.headline6!.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
              //   ),
              // )
              //     : SizedBox(),
            ],
          ),
        )
      ],
    );
  }
}
