import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/view_models/filter_view_model.dart';

import 'Circular_loading_widget.dart';

class EndDrawer extends StatefulWidget {
  const EndDrawer({Key? key}) : super(key: key);

  @override
  _EndDrawerState createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_trans.filter),
                  MaterialButton(
                    onPressed: () {
                      Provider.of<FilterViewModel>(context, listen: false)
                          .clearFilter();
                    },
                    child: Text(
                      _trans.clear,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
            ),
            Consumer<FilterViewModel>(
              builder: (context, filterModel, child) {
                return Expanded(
                  child: ListView(
                    primary: true,
                    shrinkWrap: true,
                    children: <Widget>[
                      /* ExpansionTile(
                        title: Text(_trans.delivery_or_pickup),
                        children: [
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: filterModel.filter.delivery,
                            onChanged: (value) {
                              setState(() {
                                filterModel.filter.delivery = true;
                              });
                            },
                            title: Text(
                              _trans.delivery,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: filterModel.filter.delivery ? false : true,
                            onChanged: (value) {
                              setState(() {
                                filterModel.filter.delivery = false;
                              });
                            },
                            title: Text(
                              _trans.pickup,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                        ],
                        textColor: Theme.of(context).accentColor,
                        iconColor: Theme.of(context).accentColor,
                        initiallyExpanded: true,
                      ), */
                      ExpansionTile(
                        title: Text(_trans.opened_restaurants),
                        children: [
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.trailing,
                            value: filterModel.filter.open,
                            onChanged: (value) {
                              setState(() {
                                filterModel.filter.open = value!;
                              });
                            },
                            title: Text(
                              _trans.open,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                        ],
                        textColor: Theme.of(context).accentColor,
                        iconColor: Theme.of(context).accentColor,
                        initiallyExpanded: true,
                      ),
                      filterModel.cuisines.isEmpty
                          ? CircularLoadingWidget(height: 100)
                          : ExpansionTile(
                              title: Text(_trans.cuisines),
                              children: List.generate(
                                  filterModel.cuisines.length, (index) {
                                return CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  value: filterModel.cuisines
                                      .elementAt(index)
                                      .selected,
                                  onChanged: (value) {
                                    filterModel.onChangeCuisinesFilter(index);
                                  },
                                  title: Text(
                                    filterModel.cuisines.elementAt(index).name,
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                    maxLines: 1,
                                  ),
                                );
                              }),
                              initiallyExpanded: true,
                              textColor: Theme.of(context).accentColor,
                              iconColor: Theme.of(context).accentColor,
                            ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            FlatButton(
              onPressed: () async{
                await Provider.of<FilterViewModel>(context, listen: false)
                    .saveFilter(context);
              },
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              color: Theme.of(context).accentColor,
              shape: const StadiumBorder(),
              child: Text(
                _trans.apply_filters,
                textAlign: TextAlign.start,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
