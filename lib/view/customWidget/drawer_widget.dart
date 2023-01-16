import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        children: <Widget>[
          Consumer<AuthViewModel>(
            builder: (context, auth, child) => GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('ProfileWidget');
              },
              child: auth.user == null
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            size: 32,
                            color: Theme.of(context).accentColor.withOpacity(1),
                          ),
                          SizedBox(width: 30),
                          Text(
                            _trans.guest,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    )
                  : UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.1),
                      ),
                      accountName: Text(
                        auth.user!.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      accountEmail: Text(
                        auth.user!.email,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Theme.of(context).accentColor,
                        backgroundImage: NetworkImage(auth.user!.image.thumb!),
                      ),
                    ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'HomeScreen', (route) => false,
                  arguments: {'initialPage': 2});
            },
            leading: Icon(
              Icons.store,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.home,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'HomeScreen', (route) => false,
                  arguments: {'initialPage': 0});
            },
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.notifications,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'HomeScreen', (route) => false,
                  arguments: {'initialPage': 3});
            },
            leading: Icon(
              Icons.fastfood,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.my_orders,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'AllRestaurantsScreen');
            },
            leading: Icon(
              Icons.kitchen,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.all_kitchens,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              // Navigator.pushNamedAndRemoveUntil(
              //     context, 'HomeScreen', (route) => false,
              //     arguments: 4);
              Navigator.pushNamed(context, 'FavoritesScreen');
            },
            leading: Icon(
              Icons.favorite,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.favorite_foods,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'HomeScreen', (route) => false,
                  arguments: {'initialPage': 4});
            },
            leading: Icon(
              Icons.chat,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.messages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              _trans.application_preferences,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('HelpScreen');
            },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.help_support,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, 'SettingsScreen');
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.settings,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('LanguagesScreen');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              _trans.languages,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          ListTile(
            onTap: () {
              Provider.of<SettingViewModel>(context, listen: false)
                  .changeBrightness();
            },
            leading: Icon(
              Icons.brightness_6,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              Theme.of(context).brightness == Brightness.dark
                  ? _trans.light_mode
                  : _trans.dark_mode,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Consumer<AuthViewModel>(
            builder: (context, authModel, child) {
              return authModel.user == null
                  ? Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, 'LoginScreen');
                          },
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Theme.of(context).focusColor.withOpacity(1),
                          ),
                          title: Text(
                            _trans.login,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, 'SignupScreen');
                          },
                          leading: Icon(
                            Icons.person_add,
                            color: Theme.of(context).focusColor.withOpacity(1),
                          ),
                          title: Text(
                            _trans.register,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ],
                    )
                  : Column(
                    children: [
                      ListTile(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  title: Wrap(
                                    spacing: 10,
                                    children: <Widget>[
                                      Icon(Icons.report,
                                          color: Theme.of(context).accentColor),
                                      Text(
                                        _trans.confirmation,
                                        style:  TextStyle(
                                            color: Theme.of(context).accentColor),
                                      ),
                                    ],
                                  ),
                                  content: Text(_trans
                                      .are_you_sure_you_want_to_logout),
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 25),
                                  actions: <Widget>[
                                    FlatButton(
                                      child:  Text(
                                        _trans.close,
                                        style:  TextStyle(
                                            color: Theme.of(context).accentColor),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),

                                    FlatButton(
                                      child:  Text(
                                        _trans.yes,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .accentColor),
                                      ),
                                      onPressed: () {
                                        Provider.of<AuthViewModel>(context, listen: false)
                                            .logout(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );

                          },
                          leading: Icon(
                            Icons.exit_to_app,
                            color: Theme.of(context).focusColor.withOpacity(1),
                          ),
                          title: Text(
                            _trans.log_out,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                      ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  _trans.delete_your_account,
                                ),
                                content: Text(
                                  _trans.delete_your_account_confirmation,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<AuthViewModel>(context,
                                            listen: false)
                                            .deleteAccount(context);
                                      },
                                      child: Text(
                                        _trans.yes,
                                        style: const TextStyle(color: Colors.red),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(_trans.no,
                                          style: TextStyle(
                                              color: Theme.of(context).accentColor))),
                                ],
                              ));
                        },
                        leading: Icon(
                          Icons.delete_forever,
                          color: Theme.of(context).focusColor.withOpacity(1),
                        ),
                        title: Text(
                          _trans.delete_your_account,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),

                    ],
                  );
            },
          ),
          Consumer<SettingViewModel>(
            builder: (context, settingModel, child) {
              return settingModel.setting.enableVersion
                  ? ListTile(
                      dense: true,
                      title: Text(
                        _trans.version + " " + settingModel.setting.appVersion,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      trailing: Icon(
                        Icons.remove,
                        color: Theme.of(context).focusColor.withOpacity(0.3),
                      ),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
