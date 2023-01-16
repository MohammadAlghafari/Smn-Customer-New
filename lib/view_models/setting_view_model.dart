import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/setting/model/setting.dart';
import 'package:smn_delivery_app/data/setting/setting_repo.dart';
import 'package:smn_delivery_app/view_models/home_view_model.dart';

import '../smn_customer.dart';
import 'faq_veiw_model.dart';

class SettingViewModel extends ChangeNotifier {
  Setting setting = Setting.init();
  bool loadingData = true;
  SettingRepo settingRepo;
  SharedPreferences prefs;
  Address? myAddress;

  SettingViewModel({required this.settingRepo, required this.prefs}) {
    loadSettings();
  }

  loadSettings() async {
    setting = await settingRepo.getSetting();
    setUserSettings();
    loadingData = false;
    notifyListeners();
  }

  setUserSettings() {
    if (prefs.getBool("isDark") != null && prefs.getBool("isDark")!) {
      setting.brightness = Brightness.dark;
      prefs.setBool("isDark", true);
    } else {
      prefs.setBool("isDark", false);
    }
    if (prefs.getString("languageCode") != null) {
      setting.mobileLanguage = Locale(prefs.getString("languageCode")!);
    } else {
      prefs.setString("languageCode", 'en');
    }
  }

  void changeBrightness() async {
    if (prefs.getBool("isDark") != null && prefs.getBool("isDark")!) {
      prefs.setBool("isDark", false);
      setting.brightness = Brightness.light;
    } else {
      prefs.setBool("isDark", true);
      setting.brightness = Brightness.dark;
    }
    notifyListeners();
  }

  void changeLanguage(String languageCode) async {
    Provider.of<FaqViewModel>(NavigationService.navigatorKey.currentState!.context,listen: false).listenForFaqs();
    Provider.of<HomeViewModel>(NavigationService.navigatorKey.currentState!.context,listen: false).refreshHome();
    prefs.setString("languageCode", languageCode);
    setting.mobileLanguage = Locale(languageCode);
    settingRepo.changeLanguage(languageCode);
    notifyListeners();
  }

  String getDefaultLanguage() {
    if (prefs.containsKey('languageCode')) {
      return prefs.getString('languageCode')!;
    }
    return 'en';
  }

  Future<dynamic> setCurrentLocation() async {
    var location = Location();
    final whenDone = Completer();
    Address _address = Address.fromJSON({});
    try {
      if (!await location.serviceEnabled()) {
        showSnackBar(
            message: AppLocalizations.of(
                    NavigationService.navigatorKey.currentContext!)!
                .please_make_sure_you_enable_gps_and_try_again);
        return;
      }
      location.requestService().then((value) async {
        if (!value) {
          return;
        }
        location.getLocation().then((_locationData) async {
          String _addressName = '';
          _address = Address.fromJSON({
            'cart': _addressName,
            'latitude': _locationData.latitude,
            'longitude': _locationData.longitude
          });
          myAddress = _address;
          await prefs.setString('my_address', json.encode(_address.toMap()));
          whenDone.complete(_address);
        }).catchError((e) {
          whenDone.complete(_address);
        });
      });
      return whenDone.future;
    } catch (e) {
      print(e);
    }
  }

  Future<Address?> getCurrentLocationSetting() async {
//  await prefs.clear();
    if (prefs.containsKey('my_address')) {
      myAddress = Address.fromJSON(json.decode(prefs.getString('my_address')!));
      return myAddress;
    } else {
      await setCurrentLocation();
      return myAddress;
    }
  }

  void update(User user) async {
    user.deviceToken = null;
    await settingRepo.update(user).then((value) {
      notifyListeners();
      showSnackBar(
        message:
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                .profile_settings_updated_successfully,
      );
    });
  }
}
