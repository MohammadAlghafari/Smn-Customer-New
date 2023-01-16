import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/auth/auth_repo.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart' as model;
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view/customWidget/MobileVerificationBottomSheetWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/DeliveryAddressDialog.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';
import 'package:smn_delivery_app/view_models/messages_view_model.dart';
import 'package:smn_delivery_app/view_models/notifications_view_model.dart';
import 'package:smn_delivery_app/view_models/order_view_model.dart';

import '../smn_customer.dart';

class AuthViewModel extends ChangeNotifier {
  AuthRepo authRepo;
  User? user;
  SharedPreferences prefs;
  late OverlayEntry loader;
  List<model.Address> addresses = <model.Address>[];
  model.Address? deliveryAddress;
  bool loadingDeliveryAddress = true;

  AuthViewModel({required this.authRepo, required this.prefs}) {
    loadUserFromShared();
  }

  loadUserFromShared() async {
    if (prefs.getString("current_user") != null) {
      user = User.fromJSON(json.decode(prefs.getString("current_user")!));
      listenForAddresses();
    }
  }

  Future<bool> isAuth() async {
    return prefs.getBool("isLogin") == null ? false : prefs.getBool("isLogin")!;
  }

  login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    user = await authRepo.login(email, password);
    loader.remove();
    if (user != null) {
      prefs.setBool("isLogin", true);
      prefs.setString("current_user", json.encode(user!));
      // if(routePageAfterLogin=='HomeScreen') {
      //   Navigator.pushNamedAndRemoveUntil(context, 'HomeScreen', (route) => false,
      //     arguments: {'initialPage': 2});
      // }
      // else{
      //   Navigator.pushReplacementNamed(context, routePageAfterLogin);
      // }
      refreshAfterAuth();
      notifyListeners();
      Navigator.pop(context);
    }
  }

  resetPassword(String email, BuildContext context) async {
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    bool isLinkSent = await authRepo.resetPassword(email);
    loader.remove();
    if (isLinkSent) {
      prefs.setBool("isLogin", true);
      Navigator.pushReplacementNamed(context, 'LoginScreen');
      showToast(
          message: AppLocalizations.of(context)!
              .your_reset_link_has_been_sent_to_your_email,
          context: context,
          gravity: ToastGravity.CENTER);
    } else {
      showToast(
          message: AppLocalizations.of(context)!.error_verify_email_settings,
          context: context,
          gravity: ToastGravity.CENTER);
    }
  }

  void logout(BuildContext context) {
    prefs.setBool("isLogin", false);
    prefs.remove('current_user');
    user = null;
    notifyListeners();
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     'LoginScreen', (Route<dynamic> route) => false);
    Navigator.pop(context);
  }

  updateUser(User user) {
    this.user = user;
    notifyListeners();
  }

  void listenForAddresses({String? message}) async {
    addresses = await authRepo.getAddresses(user!);
    notifyListeners();
  }

  Future<void> changeDeliveryAddress(
      model.Address address, BuildContext context) async {
    deliveryAddress = await authRepo.changeCurrentLocation(address);
    Provider.of<CartViewModel>(context, listen: false).changeDeliveryAddress();

    notifyListeners();
  }

  Future<void> changeDeliveryAddressToCurrentLocation(
      String googleMapsKey, BuildContext context) async {
    buildShowDialog(context);
    model.Address _address = await authRepo.setCurrentLocation(googleMapsKey);
    for (var element in addresses) {
      if (element.isSameAddress(_address)) {
        showToast(
            context: context,
            message: AppLocalizations.of(
                    NavigationService.navigatorKey.currentState!.context)!
                .address_already_exist);
        Navigator.pop(context);
        return;
      }
    }
    DeliveryAddressDialog(
      context: context,
      address: _address,
      onChanged: (Address _address) async {
        await addAddress(_address, context);
        chooseDeliveryAddress(_address, context);
        notifyListeners();
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
    // Navigator.pop(context);

    // addAddress(_address, context);
  }

  addAddress(model.Address address, BuildContext context) async {
    await authRepo.addAddress(address, user!).then((value) {
      chooseDeliveryAddress(value, context);
      addresses.insert(0, value);
      notifyListeners();
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).new_address_added_successfully),
      // ));
    });
  }

  void chooseDeliveryAddress(model.Address address, BuildContext context) {
    deliveryAddress = address;
    Provider.of<CartViewModel>(context, listen: false).changeDeliveryAddress();
  }

  void updateAddress(model.Address address) {
    authRepo.updateAddress(address, user!).then((value) {
      addresses.clear();
      listenForAddresses();
      // S.of(context).the_address_updated_successfully
    });
  }

  Future<void> refreshAddresses() async {
    addresses.clear();
    listenForAddresses();
  }

  void removeDeliveryAddress(model.Address address) async {
    authRepo.removeDeliveryAddress(address, user!).then((value) {
      addresses.remove(address);

      notifyListeners();
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).delivery_address_removed_successfully),
      // ));
    });
  }

  void requestForCurrentLocation(BuildContext context, String googleMapsKey) {
    OverlayEntry loader = Helper().overlayLoader(context);
    Overlay.of(context)?.insert(loader);
    authRepo.setCurrentLocation(googleMapsKey).then((_address) async {
      deliveryAddress = _address;
      notifyListeners();
      loader.remove();
    }).catchError((e) {
      loader.remove();
    });
  }

  void pickup(BuildContext context) {
    deliveryAddress = null;
    Provider.of<CartViewModel>(context, listen: false).changeDeliveryAddress();
    notifyListeners();
  }

  Future<bool> sendOTP(String phonrNumber) async {
    return await authRepo.sendOTP(phonrNumber);
  }

  Future<bool> verifyOTP(String phone, String code) async {
    return await authRepo.verifyOTP(phone, code);
  }

  Future<bool> checkRegister(
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required BuildContext context,
      required Map<String, dynamic> body}) async {
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    user = User.fromJSON(body);
    authRepo.checkRegister(body).then((value) async {
      if (value['data']['email'] == '1' && value['data']['phone'] == '1') {
        loader.remove();
        bool res = await sendOTP(body['phone']);
        if (!res) {
          return false;
        }
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: MobileVerificationBottomSheetWidget(
                scaffoldKey: scaffoldKey,
                phone: body['phone'],
                user: user!,
              ),
            );
          },
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
        ).then((value) {
          if (value != null && value) register(body, context);
        });
      } else {
        loader.remove();
        scaffoldKey.currentState?.showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.email_or_phone_already_exist)));
        return false;
      }
    }).catchError((e) {
      loader.remove();

      scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(
                NavigationService.navigatorKey.currentState!.context)!
            .these_credentials_do_not_match_our_records),
      ));
    });
    return false;
  }

  deleteAccount(
    BuildContext context,
  ) async {
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    await authRepo.deleteAccount(user!.apiToken!).then((value) {
      loader.remove();
      if (value) {
        prefs.setBool("isLogin", false);
        Navigator.of(context).pushNamedAndRemoveUntil(
            'LoginScreen', (Route<dynamic> route) => false);
      }
    });
  }

  void register(Map<String, dynamic> body, BuildContext context) async {
    FocusScope.of(context).unfocus();
    loader = Helper().overlayLoader(context);
    Overlay.of(context)!.insert(loader);
    user = await authRepo.register(body);
    loader.remove();
    Helper.hideLoader(loader);
    if (user != null && user!.apiToken != null) {
      // Navigator.pushReplacementNamed(context, 'HomeScreen', arguments: 2);
      notifyListeners();
      refreshAfterAuth();
      Navigator.pop(context);
    } else {
      showSnackBar(
          message: (AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .wrong_email_or_password));
    }

    // }).catchError((e) {
    // // scaffoldKey.currentState.showSnackBar(SnackBar(
    // //   content: Text(AppLocalizations.of(
    // //       NavigationService.navigatorKey.currentState!.context)!.thisAccountNotExist),
    // // ));
    // }).whenComplete(() {
    // });
  }

  refreshAfterAuth() {
    Provider.of<OrderViewModel>(
            NavigationService.navigatorKey.currentState!.context,
            listen: false)
        .refreshOrders();
    Provider.of<MessagesViewModel>(
            NavigationService.navigatorKey.currentState!.context,
            listen: false)
        .listenForConversations();
    Provider.of<NotificationsViewModel>(
            NavigationService.navigatorKey.currentState!.context,
            listen: false)
        .listenForNotifications();
  }
}
