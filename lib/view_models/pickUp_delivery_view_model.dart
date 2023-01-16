import 'package:flutter/cupertino.dart';
import 'package:smn_delivery_app/const/Constants.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/cart/model/PaymentMethod.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class PickupDeliveryViewModel extends ChangeNotifier {
  Address? deliveryAddress;
  PaymentMethodList list=PaymentMethodList();
  AuthViewModel authViewModel;

  PickupDeliveryViewModel({required this.authViewModel}) {
    // super.listenForCarts();
    listenForDeliveryAddress();
  }

  void listenForDeliveryAddress() async {
    deliveryAddress = authViewModel.deliveryAddress;
  }

  void addAddress(Address address, BuildContext context) {
    authViewModel.addAddress(address, context);
    notifyListeners();
  }

  void updateAddress(Address address) {
    authViewModel.updateAddress(address);
    notifyListeners();
  }

  PaymentMethod getPickUpMethod() {
    return list.pickupList.elementAt(0);
  }

  PaymentMethod getDeliveryMethod() {
    return list.pickupList.elementAt(1);
  }

  void toggleDelivery() {
    for (var element in list.pickupList) {
      if (element != getDeliveryMethod()) {
        element.selected = false;
      }
    }
    getDeliveryMethod().selected = !getDeliveryMethod().selected;
    Constants.pickupOrDelivery = true;
    notifyListeners();
  }

  void togglePickUp() {
    for (var element in list.pickupList) {
      if (element != getPickUpMethod()) {
        element.selected = false;
      }
    }
    getPickUpMethod().selected = !getPickUpMethod().selected;
    Constants.pickupOrDelivery = false;
    notifyListeners();

  }

  PaymentMethod getSelectedMethod() {
    PaymentMethod? route;
    for (var i = 0; i < list.pickupList.length; i++) {
      if (list.pickupList[i].selected) {
        route = list.pickupList[i];
        break;
      }
    }
    if (route != null) {
      return route;
    } else {
      return PaymentMethod('', '', '', '', '');
    }
  }

  void goCheckout(BuildContext context) {
    String routeName = getSelectedMethod().route;
    if (routeName == '') {
      // scaffoldKey?.currentState?.showSnackBar(SnackBar(
      //   content: Text(S.of(context).please_choose_delivery_or_pickup),
      // ));
      return;
    }
    if (routeName == '/PayOnPickup') {
      Navigator.of(context).pushNamedAndRemoveUntil(
          routeName, (route) => route.settings.name == '/Pages');
      /*  Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        routeName,
      ); */
    } else if (routeName == '/CashOnDelivery') {
      Navigator.of(context).pushNamedAndRemoveUntil(
          routeName, (route) => route.settings.name == '/Pages');
      /*  Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(routeName); */
    } else
      Navigator.of(context).pushNamed(routeName);
  }
}
