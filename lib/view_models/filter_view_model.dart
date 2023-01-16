import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/filter/filter_repo.dart';
import 'package:smn_delivery_app/data/filter/model/filter.dart';
import 'package:smn_delivery_app/data/home/model/cuisine.dart';
import 'package:smn_delivery_app/view_models/home_view_model.dart';

import '../smn_customer.dart';

class FilterViewModel extends ChangeNotifier {
  List<Cuisine> cuisines = [];
  late Filter filter;
  SharedPreferences prefs;
  FilterRepo filterRepo;

  FilterViewModel({required this.prefs, required this.filterRepo}) {
    listenForFilter();
  }

  Future<void> listenForFilter() async {
    filter = Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
    getCuisines();
  }

  Future<void> saveFilter(BuildContext context) async {
    filter.cuisines = cuisines.where((_f) => _f.selected).toList();
    prefs.setString('filter', json.encode(filter.toMap()));
    buildShowDialog(context);
    await Provider.of<HomeViewModel>(context,listen: false).applyFilter();
    Navigator.pop(context);
    Navigator.pop(context);

  }

  // void listenForCuisines() async {
  //   cuisines.add( Cuisine.fromJSON(
  //       {'id': '0', 'name': S.of(context).all, 'selected': true}));
  //   final Stream<Cuisine> stream = await getCuisines();
  //   stream.listen((Cuisine _cuisine) {
  //     setState(() {
  //       if (filter.cuisines.contains(_cuisine)) {
  //         _cuisine.selected = true;
  //         cuisines.elementAt(0).selected = false;
  //       }
  //       cuisines.add(_cuisine);
  //     });
  //   }, onError: (a) {
  //     print(a);
  //     scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //       content: Text(S.of(context).verify_your_internet_connection),
  //     ));
  //   }, onDone: () {
  //     if (messages != null) {
  //       scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //         content: Text(messages),
  //       ));
  //     }
  //   });
  // }

  Future<void> getCuisines() async {
    cuisines.clear();
    cuisines.add(Cuisine.fromJSON({
      'id': '0',
      'name':
          AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
              .all,
      'selected': true
    }));
    cuisines.addAll(await filterRepo.getCuisines());

    for (int i = 0; i < cuisines.length; i++) {
      if (filter.cuisines.contains(cuisines[i])) {
        cuisines[i].selected = true;
        //disable all
        cuisines[0].selected = false;
      }
    }

    notifyListeners();
  }

  void clearFilter() {
    filter.open = false;
    filter.delivery = false;
    resetCuisines();
  }

  void resetCuisines() {
    filter.cuisines = [];
    for (var _f in cuisines) {
      _f.selected = false;
    }
    cuisines.elementAt(0).selected = true;
    notifyListeners();
  }

  void onChangeCuisinesFilter(int index) {
    if (index == 0) {
      // all
      resetCuisines();
    } else {
      cuisines.elementAt(index).selected = !cuisines.elementAt(index).selected;
      cuisines.elementAt(0).selected = false;
      notifyListeners();
    }
  }
}
