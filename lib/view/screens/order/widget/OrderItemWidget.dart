import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodOrderItemWidget.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

import '../../../../generated/l10n.dart';

class OrderItemWidget extends StatefulWidget {
  final bool expanded;
  final Order order;
  final ValueChanged<void> onCanceled;

  OrderItemWidget(
      {Key? key,
      required this.expanded,
      required this.order,
      required this.onCanceled})
      : super(key: key);

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: widget.order.active ? 1 : 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 14),
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Theme(
                  data: theme,
                  child: ExpansionTile(
                    initiallyExpanded: widget.expanded,
                    title: Column(
                      children: <Widget>[
                        Text('${_trans.order_id}: #${widget.order.id}'),
                        Text(
                          DateFormat('dd-MM-yyyy | HH:mm')
                              .format(widget.order.dateTime),
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Helper.getPrice(
                           double.parse(widget.order.payment.price.toString()),
                            context,
                            style: Theme.of(context).textTheme.headline4),
                        Text(
                          '${widget.order.payment.method}',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    children: <Widget>[
                      Column(
                          children: List.generate(
                        widget.order.foodOrders.length,
                        (indexFood) {
                          return FoodOrderItemWidget(
                              heroTag: 'mywidget.orders',
                              order: widget.order,
                              foodOrder:
                                  widget.order.foodOrders.elementAt(indexFood));
                        },
                      )),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _trans.delivery_fee,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(
                                    widget.order.deliveryFee, context,
                                    style:
                                        Theme.of(context).textTheme.subtitle1)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    '${_trans.tax} (${widget.order.tax}%)',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(
                                    Helper.getTaxOrder(widget.order), context,
                                    style:
                                        Theme.of(context).textTheme.subtitle1)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    _trans.total,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Helper.getPrice(
                                   double.parse(widget.order.payment.price.toString()) ,
                                    context,
                                    style:
                                        Theme.of(context).textTheme.headline4)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  alignment: WrapAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('TrackingWidget', arguments: widget.order);
                      },
                      textColor: Theme.of(context).hintColor,
                      child: Wrap(
                        children: <Widget>[Text(_trans.view)],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    if (widget.order.canCancelOrder())
                      FlatButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: Wrap(
                                  spacing: 10,
                                  children: <Widget>[
                                     Icon(Icons.report, color: Theme.of(context).accentColor),
                                    Text(
                                      _trans.confirmation,
                                      style:  TextStyle(color: Theme.of(context).accentColor),
                                    ),
                                  ],
                                ),
                                content: Text(
                                    _trans.areYouSureYouWantToCancelThisOrder),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 25),
                                actions: <Widget>[


                                  FlatButton(
                                    child:  Text(
                                      _trans.close,
                                      style:  TextStyle(color: Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child:  Text(
                                      _trans.yes,
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    onPressed: () {
                                      widget.onCanceled(widget.order);
                                      Navigator.of(context).pop();
                                    },
                                  ),

                                ],
                              );
                            },
                          );
                        },
                        textColor: Theme.of(context).hintColor,
                        child: Wrap(
                          children: <Widget>[Text(_trans.cancel + " ")],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(start: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 28,
          width: 140,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(100)),
              color: widget.order.active
                  ? Theme.of(context).accentColor
                  : Colors.redAccent),
          alignment: AlignmentDirectional.center,
          child: Text(
            widget.order.active
                ? widget.order.orderStatus.status
                : _trans.canceled,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            style: Theme.of(context).textTheme.caption!.merge(
                TextStyle(height: 1, color: Theme.of(context).primaryColor)),
          ),
        ),
      ],
    );
  }
}
