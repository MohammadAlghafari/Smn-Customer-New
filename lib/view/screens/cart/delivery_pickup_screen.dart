import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/Constants.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/DeliveryAddressBottomSheetWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/delivery_pichup_BottomDetails.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';
import 'package:smn_delivery_app/view_models/pickUp_delivery_view_model.dart';

class DeliveryPickupScreen extends StatefulWidget {
  const DeliveryPickupScreen({Key? key}) : super(key: key);

  @override
  _DeliveryPickupScreenState createState() => _DeliveryPickupScreenState();
}

class _DeliveryPickupScreenState extends State<DeliveryPickupScreen> {
  bool valueToday = true;
  bool valueSchedule = false;
  DateTime? time;
  late AppLocalizations _trans;
  int paymentMethod = 1;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      key: scaffoldKey,
      bottomNavigationBar: DeliveryPichupBottomDetails(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.delivery_or_pickup,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: valueToday,
                      onChanged: (bool? value) {
                        setState(() {
                          valueToday = value ?? false;
                          if (valueSchedule == true) {
                            valueSchedule = false;
                          }
                          time = null;
                          Constants.time = null;
                          Constants.date = DateTime.now();
                          paymentMethod = 0;
                        });
                        // if (!valueToday) {
                        //   setState(() {
                        //     paymentMethod = 0;
                        //   });
                        // }
                      },
                      activeColor: Theme.of(context).hintColor,
                    ),
                    Text(
                      _trans.today,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: valueSchedule,
                          onChanged: (bool? value) {
                            setState(() {});
                            DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day + 1),
                              maxTime: DateTime(
                                  DateTime.now().year,
                                  DateTime.now().month,
                                  DateTime.now().day + 7,
                                  23,
                                  59),
                              onChanged: (date) {
                                print('change $date');
                              },
                              onConfirm: (date) {
                                setState(() {
                                  Constants.date = date;
                                  Constants.time = DateFormat.Hm().format(date);
                                  time = date;
                                  valueSchedule = true;
                                  if (valueToday == true) {
                                    valueToday = false;
                                  }
                                });
                                print('confirm $date');
                              },
                              currentTime: DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day + 1),
                            );
                          },
                          activeColor: Theme.of(context).hintColor,
                        ),
                        Text(
                          _trans.schedule,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    ),
                    time == null || valueToday == true
                        ? SizedBox()
                        : Text(DateFormat.yMd().add_Hm().format(time!))
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.domain,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  _trans.pickup,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline4,
                ),
                subtitle: Text(
                  _trans.pickup_your_food_from_the_restaurant,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
            ),
            InkWell(
              splashColor: Theme.of(context).accentColor,
              focusColor: Theme.of(context).accentColor,
              highlightColor: Theme.of(context).primaryColor,
              onTap: () {
                if (valueSchedule == false && valueToday == false) {
                  showToast(
                      context: context,
                      message: _trans.please_choose_Today_or_schedule);
                } else {
                  setState(() {
                    paymentMethod = 1;
                    Provider.of<CartViewModel>(context, listen: false)
                        .paymentMethod = 'Pay on Pickup';
                    buildShowDialog(context);
                    Provider.of<AuthViewModel>(context, listen: false)
                        .deliveryAddress = null;
                    Provider.of<CartViewModel>(context, listen: false)
                        .changeDeliveryAddress()
                        .whenComplete(() => Navigator.pop(context));
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            image: DecorationImage(
                                image: AssetImage('assets/img/pay_pickup.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Container(
                          height: paymentMethod == 1 ? 60 : 0,
                          width: paymentMethod == 1 ? 60 : 0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Theme.of(context)
                                .accentColor
                                .withOpacity(paymentMethod == 1 ? 0.74 : 0),
                          ),
                          child: Icon(
                            Icons.check,
                            size: paymentMethod == 1 ? 44 : 0,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(paymentMethod == 1 ? 0.9 : 0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _trans.pay_on_pickup,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  _trans.pickup_your_food_from_the_restaurant,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Consumer2<CartViewModel, PickupDeliveryViewModel>(
              builder: (context, cartModel, pdModel, child) {
                if (cartModel.cartItems.isNotEmpty &&
                    !cartModel
                        .cartItems[0].food.restaurant.availableForDelivery) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    InkWell(
                      splashColor: Theme.of(context).accentColor,
                      focusColor: Theme.of(context).accentColor,
                      highlightColor: Theme.of(context).primaryColor,
                      onTap: () {
                        // widget.onPressed(widget.paymentMethod);
                        if (valueSchedule == false && valueToday == false) {
                          showToast(
                              context: context,
                              message: _trans.please_choose_Today_or_schedule);
                        } else {
                          if (Provider.of<AuthViewModel>(context, listen: false)
                              .addresses
                              .isNotEmpty) {
                            Provider.of<AuthViewModel>(context, listen: false)
                                .deliveryAddress ??= Provider.of<AuthViewModel>(
                                    context,
                                    listen: false)
                                .addresses[0];
                          } else {
                            Provider.of<CartViewModel>(context, listen: false)
                                .paymentMethod = 'Cash on Delivery';
                            Provider.of<AuthViewModel>(context, listen: false)
                                .deliveryAddress = null;
                            showToast(
                                context: context,
                                message: AppLocalizations.of(context)!
                                    .add_delivery_address);
                            return;
                          }
                          setState(() {
                            paymentMethod = 2;
                          });
                          buildShowDialog(context);
                          Provider.of<CartViewModel>(context, listen: false)
                              .changeDeliveryAddress()
                              .whenComplete(() => Navigator.pop(context));
                          Provider.of<CartViewModel>(context, listen: false)
                              .paymentMethod = 'Cash on Delivery';
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.1),
                                blurRadius: 5,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/img/pay_pickup.png'),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                Container(
                                  height: paymentMethod == 2 ? 60 : 0,
                                  width: paymentMethod == 2 ? 60 : 0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Theme.of(context)
                                        .accentColor
                                        .withOpacity(
                                            paymentMethod == 2 ? 0.74 : 0),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: paymentMethod == 2 ? 44 : 0,
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(
                                            paymentMethod == 2 ? 0.9 : 0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _trans.delivery_address,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1,
                                        ),
                                        Text(
                                          _trans.click_to_pay_on_delivery,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 10, left: 20, right: 10),
                      child: ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          leading: Icon(
                            Icons.map,
                            color: Theme.of(context).hintColor,
                          ),
                          title: Text(
                            _trans.delivery,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          subtitle: Text(
                            _trans
                                .click_to_confirm_your_address_and_pay_or_long_press,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                          )),
                    ),
                    Consumer<AuthViewModel>(
                      builder: (context, authModel, child) {
                        return Column(
                          children: [
                            authModel.deliveryAddress == null
                                ? Container()
                                : InkWell(
                                    splashColor: Theme.of(context).accentColor,
                                    focusColor: Theme.of(context).accentColor,
                                    highlightColor:
                                        Theme.of(context).primaryColor,
                                    onTap: () {
                                      // this.onPressed(address);
                                      if (valueSchedule == false &&
                                          valueToday == false) {
                                        showToast(
                                            context: context,
                                            message: _trans
                                                .please_choose_Today_or_schedule);
                                      } else {
                                        buildShowDialog(context);
                                        setState(() {
                                          paymentMethod = 2;
                                        });
                                        // authModel.deliveryAddress;
                                        Provider.of<CartViewModel>(context,
                                                listen: false)
                                            .changeDeliveryAddress()
                                            .whenComplete(
                                                () => Navigator.pop(context));
                                        Provider.of<CartViewModel>(context,
                                                listen: false)
                                            .paymentMethod = 'Cash on Delivery';
                                      }
                                    },
                                    onLongPress: () {
                                      if (valueSchedule == false &&
                                          valueToday == false) {
                                        showToast(
                                            context: context,
                                            message: _trans
                                                .please_choose_Today_or_schedule);
                                      } else {
                                        var bottomSheetController = scaffoldKey
                                            .currentState!
                                            .showBottomSheet(
                                          (context) =>
                                              const DeliveryAddressBottomSheetWidget(),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                        );
                                        bottomSheetController.closed
                                            .then((value) {
                                          setState(() {});
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.9),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.1),
                                              blurRadius: 5,
                                              offset: Offset(0, 2)),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: <Widget>[
                                              Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(8)),
                                                    color: (paymentMethod == 2)
                                                        ? Theme.of(context)
                                                            .accentColor
                                                        : Theme.of(context)
                                                            .focusColor),
                                                child: Icon(
                                                  paymentMethod == 2
                                                      ? Icons.check
                                                      : Icons.place,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 38,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 15),
                                          Flexible(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        getAddressName(
                                                            authModel),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .subtitle1,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 10),
                            Container(
                              width: 55,
                              height: 40,
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  if (valueSchedule == false &&
                                      valueToday == false) {
                                    showToast(
                                        context: context,
                                        message: _trans
                                            .please_choose_Today_or_schedule);
                                  } else {
                                    var bottomSheetController = scaffoldKey
                                        .currentState!
                                        .showBottomSheet(
                                      (context) =>
                                          const DeliveryAddressBottomSheetWidget(),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                      ),
                                    );
                                    bottomSheetController.closed.then((value) {
                                      if (Provider.of<AuthViewModel>(context,
                                                  listen: false)
                                              .deliveryAddress ==
                                          null) return;
                                      setState(() {
                                        buildShowDialog(context);
                                        paymentMethod = 2;
                                        // authModel.deliveryAddress ??=
                                        //     authModel.addresses[0];
                                        Provider.of<CartViewModel>(context,
                                                listen: false)
                                            .changeDeliveryAddress()
                                            .whenComplete(
                                                () => Navigator.pop(context));
                                        Provider.of<CartViewModel>(context,
                                                listen: false)
                                            .paymentMethod = 'Cash on Delivery';
                                      });
                                    });
                                  }
                                },
                                child: Icon(Icons.edit_location_outlined,
                                    color: Theme.of(context).primaryColor),
                                color: Theme.of(context).accentColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String getAddressName(AuthViewModel authModel) {
    if (authModel.deliveryAddress != null) {
      if (authModel.deliveryAddress!.description.isNotEmpty) {
        return authModel.deliveryAddress!.description;
      } else {
        return authModel.deliveryAddress!.address ?? _trans.unknown;
      }
    }
    if (authModel.addresses.isNotEmpty) {
      if (authModel.addresses[0].description.isNotEmpty) {
        return authModel.addresses[0].description;
      } else {
        return authModel.addresses[0].address!;
      }
    }
    return _trans.unknown;
  }
}
