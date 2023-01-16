import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/customWidget/PermissionDeniedWidget.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/screens/settings/profile_number_settings_dialog.dart';
import 'package:smn_delivery_app/view/screens/settings/profile_settings_dialog.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
        key: scaffoldKey,
        //drawer: const DrawerWidget(),
        appBar: AppBar(
          /* leading: IconButton(
            icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => scaffoldKey.currentState!.openDrawer(),
          ), */
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            _trans.settings,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .merge(TextStyle(letterSpacing: 1.3)),
          ),
        ),
        body: Consumer<AuthViewModel>(
          builder: (context, authModel, child) {
            return authModel.user== null
                ? PermissionDeniedWidget()
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      authModel.user!.name,
                                      textAlign: TextAlign.left,
                                      style:
                                          Theme.of(context).textTheme.headline3,
                                    ),
                                    Text(
                                      authModel.user!.email,
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              ),
                              SizedBox(
                                  width: 55,
                                  height: 55,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(300),
                                    onTap: () {
                                      Navigator.of(context).pushNamed('ProfileWidget');

                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          authModel.user!.image.thumb!),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            primary: false,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text(
                                  _trans.profile_settings,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ButtonTheme(
                                      padding: EdgeInsets.all(0),
                                      minWidth: 50.0,
                                      height: 25.0,
                                      child: ProfileSettingsDialog(
                                        user: authModel.user!,
                                        onChanged: () {
                                          Provider.of<SettingViewModel>(context,listen: false).update(authModel.user!);
                                          //setState(() {});
                                        },
                                      ),
                                    ),
                                    ButtonTheme(
                                      padding: EdgeInsets.all(0),
                                      minWidth: 50.0,
                                      height: 25.0,
                                      child: ProfileNumberSettingsDialog(
                                        scaffoldKey: scaffoldKey,
                                        user: authModel.user!,
                                        onChanged: () {
                                          Provider.of<SettingViewModel>(context,listen: false).update(authModel.user!);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListTile(
                                onTap: () {},
                                dense: true,
                                title: Text(
                                  _trans.full_name,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                trailing: Text(
                                  authModel.user!.name,
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                              ListTile(
                                onTap: () {},
                                dense: true,
                                title: Text(
                                  _trans.email,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                trailing: Text(
                                  authModel.user!.email,
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                              ListTile(
                                onTap: () {},
                                dense: true,
                                title: Text(
                                  _trans.phone,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                trailing: Text(
                                  authModel.user!.phone!,
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                              ListTile(
                                onTap: () {},
                                dense: true,
                                title: Text(
                                  _trans.address,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                trailing: Text(
                                  Helper.limitString(authModel.user!.address!),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                              ListTile(
                                onTap: () {},
                                dense: true,
                                title: Text(
                                  _trans.about,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                trailing: Text(
                                  Helper.limitString(authModel.user!.bio!),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Theme.of(context).focusColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.15),
                                  offset: Offset(0, 3),
                                  blurRadius: 10)
                            ],
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            primary: false,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.settings),
                                title: Text(
                                  _trans.app_settings,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed('LanguagesScreen');
                                },
                                dense: true,
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.translate,
                                      size: 22,
                                      color: Theme.of(context).focusColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      _trans.languages,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                                trailing: Consumer<SettingViewModel>(
                                  builder: (context, settingsModel, child) {
                                    return Text(
                                      settingsModel.setting.mobileLanguage
                                                  .languageCode ==
                                              'en'
                                          ? _trans.english
                                          : _trans.arabic,
                                      style: TextStyle(
                                          color: Theme.of(context).focusColor),
                                    );
                                  },
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('DeliveryAddressesScreen');
                                },
                                dense: true,
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.place,
                                      size: 22,
                                      color: Theme.of(context).focusColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      _trans.delivery_addresses,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),

                              ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed('HelpScreen');
                                },
                                dense: true,
                                title: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.help,
                                      size: 22,
                                      color: Theme.of(context).focusColor,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      _trans.help_support,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ));
  }
}
