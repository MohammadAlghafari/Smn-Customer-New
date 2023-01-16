import 'dart:async';

import 'package:flutter/material.dart';

import 'package:smn_delivery_app/utili/app_config.dart' as config;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyCartWidget extends StatefulWidget {
  EmptyCartWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EmptyCartWidgetState createState() => _EmptyCartWidgetState();
}

class _EmptyCartWidgetState extends State<EmptyCartWidget> {
  late AppLocalizations _trans;


  @override
  Widget build(BuildContext context) {
    _trans=AppLocalizations.of(context)!;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            height: config.App().appHeight(70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [
                            Theme.of(context).focusColor.withOpacity(0.7),
                            Theme.of(context).focusColor.withOpacity(0.05),
                          ])),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        size: 70,
                      ),
                    ),
                    Positioned(
                      right: -30,
                      bottom: -50,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -20,
                      top: -50,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(150),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Opacity(
                  opacity: 0.4,
                  child: Text(
                    _trans.dont_have_any_item_in_your_cart,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3!.merge(const TextStyle(fontWeight: FontWeight.w300)),
                  ),
                ),
                const SizedBox(height: 50),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'HomeScreen', (route) => false,
                        arguments: {'initialPage':2});
                  },
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  color: Theme.of(context).accentColor.withOpacity(1),
                  shape: const StadiumBorder(),
                  child: Text(
                    _trans.start_exploring,
                    style: Theme.of(context).textTheme.headline6!.merge(TextStyle(color: Theme.of(context).scaffoldBackgroundColor)),
                  ),
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
