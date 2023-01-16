import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../generated/l10n.dart';
import 'package:smn_delivery_app/utili/app_config.dart' as config;

class EmptySearchWidget extends StatefulWidget {
  EmptySearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  _EmptySearchWidgetState createState() => _EmptySearchWidgetState();
}

class _EmptySearchWidgetState extends State<EmptySearchWidget> {
  bool loading = true;
  late AppLocalizations _trans;

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
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
            : const SizedBox(),
        Container(
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: config.App().appHeight(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Opacity(
                opacity: 0.4,
                child: Text(
                  _trans.nothing_found,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3!.merge(const TextStyle(fontWeight: FontWeight.w300)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    );
  }
}
