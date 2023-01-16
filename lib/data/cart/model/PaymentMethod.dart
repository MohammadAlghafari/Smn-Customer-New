import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/smn_customer.dart';


class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  bool isDefault;
  bool selected;

  PaymentMethod(this.id, this.name, this.description, this.route, this.logo, {this.isDefault = false, this.selected = false});
}

class PaymentMethodList {
  late List<PaymentMethod> _paymentsList;
  late List<PaymentMethod> _cashList;
  late List<PaymentMethod> _pickupList;

  PaymentMethodList() {
    _paymentsList = [
       PaymentMethod("visacard",AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.visa_card, AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.click_to_pay_with_your_visa_card, "/Checkout", "assets/img/visacard.png",
          isDefault: true),
       PaymentMethod("mastercard", AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.mastercard, AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.click_to_pay_with_your_mastercard, "/Checkout", "assets/img/mastercard.png"),
       PaymentMethod("razorpay", AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.razorpay, AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.clickToPayWithRazorpayMethod, "/RazorPay", "assets/img/razorpay.png"),
       PaymentMethod("paypal", AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.paypal, AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.click_to_pay_with_your_paypal_account, "/PayPal", "assets/img/paypal.png"),
    ];
    _cashList = [
       PaymentMethod("cod", AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.cash_on_delivery, AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.click_to_pay_cash_on_delivery, "/CashOnDelivery", "assets/img/cash.png"),
    ];
    _pickupList = [
       PaymentMethod("pop", AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.pay_on_pickup, AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.click_to_pay_on_pickup, "/PayOnPickup", "assets/img/pay_pickup.png"),
       PaymentMethod("delivery", AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.delivery_address, AppLocalizations.of(NavigationService.navigatorKey.currentState!.context)!.click_to_pay_on_delivery, "/PaymentMethod", "assets/img/pay_pickup.png"),
    ];
  }

  List<PaymentMethod> get paymentsList => _paymentsList;
  List<PaymentMethod> get cashList => _cashList;
  List<PaymentMethod> get pickupList => _pickupList;
}
