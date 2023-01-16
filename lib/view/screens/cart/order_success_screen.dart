import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/utili/helper.dart';

class OrderSuccessScreen extends StatefulWidget {
  double total;
  double subtotal;
  double? subTotalWithoutCoupon;
  double deliveryFee;
  String paymentMethod;
  double taxAmount;
  String defaultTax;

  OrderSuccessScreen(
      {Key? key,
      required this.deliveryFee,
      required this.total,
      required this.taxAmount,
      required this.paymentMethod,
      required this.defaultTax,
       this.subTotalWithoutCoupon,
      required this.subtotal})
      : super(key: key);

  @override
  _OrderSuccessScreenState createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushNamedAndRemoveUntil(
            context, 'HomeScreen', (route) => false,
            arguments: {'initialPage':3});
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              _trans.confirmation,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(const TextStyle(letterSpacing: 1.3)),
            ),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                alignment: AlignmentDirectional.center,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.green.withOpacity(1),
                                    Colors.green.withOpacity(0.2),
                                  ])),
                          child: Icon(
                            Icons.check,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            size: 90,
                          ),
                        ),
                        Positioned(
                          right: -30,
                          bottom: -50,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(150),
                            ),
                          ),
                        ),
                        Positioned(
                          left: -20,
                          top: -50,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(150),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Opacity(
                      opacity: 0.4,
                      child: Text(
                        _trans.your_order_has_been_successfully_submitted,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline3!
                            .merge(const TextStyle(fontWeight: FontWeight.w300)),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 235,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).focusColor.withOpacity(0.15),
                            offset: const Offset(0, -2),
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
                            widget.subTotalWithoutCoupon != null
                                ? Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Helper.getPrice(
                                  widget.subTotalWithoutCoupon!,
                                  context,
                                  style: Theme.of(context).textTheme.bodyText2!.merge(
                                      const TextStyle(
                                          decoration: TextDecoration.lineThrough))),
                            )
                                : Container(),
                            Helper.getPrice(widget.subtotal, context,
                                style: Theme.of(context).textTheme.subtitle1,zeroPlaceholder: '0')
                          ],
                        ),
                        const SizedBox(height: 3),
                        widget.paymentMethod == 'Pay on Pickup'
                            ? const SizedBox(height: 0)
                            : Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      _trans.delivery_fee,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                  Helper.getPrice(widget.deliveryFee, context,
                                      style:
                                          Theme.of(context).textTheme.subtitle1)
                                ],
                              ),
                        const SizedBox(height: 3),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${_trans.tax} (${widget.defaultTax}%)",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Helper.getPrice(widget.taxAmount, context,
                                style: Theme.of(context).textTheme.subtitle1)
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _trans.total,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),

                            Helper.getPrice(widget.total, context,
                                style: Theme.of(context).textTheme.headline6)
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 40,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'HomeScreen', (route) => false,
                                  arguments: {'initialPage':3});
                            },
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            color: Theme.of(context).accentColor,
                            shape: const StadiumBorder(),
                            child: Text(
                              _trans.my_orders,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
