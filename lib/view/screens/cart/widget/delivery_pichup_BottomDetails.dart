import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/home/model/payment.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';

import '../../../../generated/l10n.dart';
import 'EmptyCartWidget.dart';

class DeliveryPichupBottomDetails extends StatelessWidget {
  DeliveryPichupBottomDetails({Key? key}) : super(key: key);
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Consumer<CartViewModel>(
      builder: (context, cartModel, child) {
        if(cartModel.cartItems.isEmpty)return EmptyCartWidget();
        return Container(
          height: 175,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).focusColor.withOpacity(0.15),
                    offset: Offset(0, -2),
                    blurRadius: 5.0)
              ]),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _trans.subtotal,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    cartModel.coupon != null&&cartModel.coupon!.valid!
                        ? Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Helper.getPrice(
                          cartModel.subTotalWithoutCoupon,
                          context,
                          style: Theme.of(context).textTheme.bodyText2!.merge(
                              const TextStyle(
                                  decoration: TextDecoration.lineThrough))),
                        )
                        : Container(),
                    Helper.getPrice(cartModel.subTotal, context,
                        style: Theme.of(context).textTheme.subtitle1,
                        zeroPlaceholder: '0')
                  ],
                ),

                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _trans.delivery_fee,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    //if (Helper.canDelivery(_con.carts[0].food.restaurant, carts: _con.carts))
                    Helper.getPrice(
                        cartModel.deliveryFee,
                        context,
                        style: Theme.of(context).textTheme.subtitle1)
                    //else
                    //Helper.getPrice(0, context, style: Theme.of(context).textTheme.subtitle1, zeroPlaceholder: 'Free')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${_trans.tax} (${cartModel.cartItems[0].food.restaurant.defaultTax}%)',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Helper.getPrice(cartModel.taxAmount, context,
                        style: Theme.of(context).textTheme.subtitle1)
                  ],
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: (){
                    buildShowDialog(context);
                    cartModel.addOrder(context);
                  },
                  child: Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: FlatButton(
                          onPressed: () {
                            buildShowDialog(context);
                           cartModel.addOrder(context);
                          },
                          disabledColor:
                          Theme.of(context).focusColor.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          color: !cartModel.cartItems[0].food.restaurant.closed
                              ? Theme.of(context).accentColor
                              : Theme.of(context).focusColor.withOpacity(0.5),
                          shape: StadiumBorder(),
                          child: Text(
                            _trans.checkout,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyText1!.merge(
                                TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Helper.getPrice(cartModel.total, context,
                            style: Theme.of(context).textTheme.headline4!.merge(
                                TextStyle(color: Theme.of(context).primaryColor))),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
