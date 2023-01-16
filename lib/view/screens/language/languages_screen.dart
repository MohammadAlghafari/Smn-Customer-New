import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/data/setting/model/language.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';


class LanguagesScreen extends StatefulWidget {
  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  late LanguagesList languagesList;
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    languagesList =  LanguagesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      // drawer: const DrawerWidget(),
      key: scaffoldKey,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
        //   onPressed: () => scaffoldKey.currentState!.openDrawer(),
        // ),
        centerTitle: true,
        title: Text(
          _trans.languages,
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
           ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.translate,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  _trans.app_language,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(_trans.select_your_preferred_languages),
              ),
            ),
            SizedBox(height: 10),
            Consumer<SettingViewModel>(builder: (context, settingsModel, child) {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: languagesList.languages.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  Language _language = languagesList.languages.elementAt(index);
                  String _langCode=settingsModel.getDefaultLanguage();
                  if (_langCode == _language.code) {
                    _language.selected = true;
                  }
                  return InkWell(
                    onTap: () async {
                      languagesList.languages.forEach((_l) {
                        setState(() {
                          _l.selected = false;
                        });
                      });
                      settingsModel.changeLanguage(_language.code);
                      _language.selected = !_language.selected;

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            alignment: AlignmentDirectional.center,
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                  image: DecorationImage(image: AssetImage(_language.flag), fit: BoxFit.cover),
                                ),
                              ),
                              Container(
                                height: _language.selected ? 40 : 0,
                                width: _language.selected ? 40 : 0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(40)),
                                  color: Theme.of(context).accentColor.withOpacity(_language.selected ? 0.85 : 0),
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: _language.selected ? 24 : 0,
                                  color: Theme.of(context).primaryColor.withOpacity(_language.selected ? 0.85 : 0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _language.englishName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  _language.localName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },),
          ],
        ),
      ),
    );
  }
}
