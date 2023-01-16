import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/myColors.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/data/order/model/order_status.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodOrderItemWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/order_view_model.dart';
import 'package:smn_delivery_app/view_models/review_view_model.dart';

import '../../food/widget/FoodOrderItemWidget.dart';

class TrackingWidget extends StatefulWidget {
  Order order;

  TrackingWidget({Key? key, required this.order}) : super(key: key);

  @override
  _TrackingWidgetState createState() => _TrackingWidgetState();
}

class _TrackingWidgetState extends State<TrackingWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;
  late AppLocalizations _trans;

  @override
  void initState() {
    // _con.listenForOrder(orderId: widget.routeArgument.id);
    _tabController =
        TabController(length: 2, initialIndex: _tabIndex, vsync: this);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _tabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.order.orderStatus.id);
    _trans = AppLocalizations.of(context)!;
    //final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent, accentColor: Theme.of(context).accentColor);
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
        bottomNavigationBar: widget.order.orderStatus.id == '5' ||
                widget.order.orderStatus.id == '6'
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 135,
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(_trans.how_would_you_rate_this_restaurant,
                        style: Theme.of(context).textTheme.subtitle1),
                    Text(_trans.click_on_the_stars_below_to_leave_comments,
                        style: Theme.of(context).textTheme.caption),
                    const SizedBox(height: 5),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'ReviewsScreen',
                            arguments: widget.order);
                      },
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      shape: const StadiumBorder(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: Helper.getStarsList(
                            double.parse(widget
                                .order.foodOrders[0].food.restaurant.rate),
                            size: 35),
                      ),
                    )
                  ],
                ),
              )
            : Container(
                height: 1,
              ),
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            centerTitle: true,
            title: Text(
              _trans.orderDetails,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(const TextStyle(letterSpacing: 1.3)),
            ),
            actions: <Widget>[
              ShoppingCartButtonWidget(
                  iconColor: Theme.of(context).hintColor,
                  labelColor: Theme.of(context).colorScheme.secondary),
            ],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            bottom: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                unselectedLabelColor: Theme.of(context).colorScheme.secondary,
                labelColor: Theme.of(context).primaryColor,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Theme.of(context).colorScheme.secondary),
                tabs: [
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(_trans.details),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(_trans.tracking_order),
                      ),
                    ),
                  ),
                ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Offstage(
                offstage: 0 != _tabIndex,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Opacity(
                        opacity: widget.order.active ? 1 : 0.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 14),
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 5),
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
                                      offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Theme(
                                data: theme,
                                child: ExpansionTile(
                                  initiallyExpanded: true,
                                  title: Column(
                                    children: <Widget>[
                                      Text(
                                          '${_trans.order_id}: #${widget.order.id}'),
                                      Text(
                                        _trans.orderDeliveryTime +
                                            ' ' +
                                            DateFormat('HH:mm | yyyy-MM-dd').format(widget.order.dateTime),
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Helper.getPrice(
                                          double.parse(widget.order.payment.price.toString()),
                                          context,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4),
                                      Text(
                                        '${widget.order.payment.method}',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      )
                                    ],
                                  ),
                                  children: <Widget>[
                                    Column(
                                        children: List.generate(
                                      widget.order.foodOrders.length,
                                      (indexFood) {
                                        return FoodOrderItemWidget(
                                            heroTag: 'my_order',
                                            taped: false,
                                            order: widget.order,
                                            foodOrder: widget.order.foodOrders
                                                .elementAt(indexFood));
                                      },
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  _trans.delivery_fee,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              Helper.getPrice(
                                                  widget.order.deliveryFee,
                                                  context,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1)
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  '${_trans.tax} (${widget.order.tax}%)',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              Helper.getPrice(
                                                  Helper.getTaxOrder(
                                                      widget.order),
                                                  context,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1)
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  _trans.total,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              Helper.getPrice(
                                                  double.parse(widget.order.payment.price.toString()),
                                                  context,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4)
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
                                                   Icon(Icons.report,
                                                      color:  Theme.of(context).accentColor),
                                                  Text(
                                                    _trans.confirmation,
                                                    style:  TextStyle(
                                                        color:  Theme.of(context).accentColor),
                                                  ),
                                                ],
                                              ),
                                              content: Text(_trans
                                                  .areYouSureYouWantToCancelThisOrder),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 25),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    _trans.close,
                                                    style:  TextStyle(
                                                        color:  Theme.of(context).accentColor),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text(
                                                    _trans.yes,
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .accentColor),
                                                  ),
                                                  onPressed: () {
                                                    Provider.of<OrderViewModel>(
                                                        context,
                                                        listen: false)
                                                        .doCancelOrder(
                                                        widget.order);
                                                    Navigator.of(context).pop();
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
                                        children: <Widget>[
                                          Text(_trans.cancelOrder + " ",
                                              style:
                                                  const TextStyle(height: 1.3)),
                                          const Icon(Icons.clear)
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 28,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(100)),
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
                              TextStyle(
                                  height: 1,
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Offstage(
                offstage: 1 != _tabIndex,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Theme(
                        data: ThemeData(
                          primaryColor: Theme.of(context).accentColor,
                        ),
                        child: Theme(
                          data: ThemeData(
                            primarySwatch: Colors.deepOrange,
                          ),
                          child: Stepper(
                            physics: const ClampingScrollPhysics(),
                            controlsBuilder: (context, details) {
                              return const SizedBox();
                            },
                            steps: getTrackingSteps(context),
                            currentStep:
                                int.tryParse(widget.order.orderStatus.id)! - 1,
                          ),
                        ),
                      ),
                    ),
                    widget.order.deliveryAddress!.address != null
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black38
                                          : Theme.of(context).backgroundColor),
                                  child: Icon(
                                    Icons.place,
                                    color: Theme.of(context).primaryColor,
                                    size: 38,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget
                                            .order.deliveryAddress!.description,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        widget.order.deliveryAddress!.address ??
                                            _trans.unknown,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(height: 0),
                    const SizedBox(height: 30)
                  ],
                ),
              ),
            ]),
          )
        ]));
  }

  List<Step> getTrackingSteps(BuildContext context) {
    List<Step> _orderStatusSteps = [];
    Provider.of<OrderViewModel>(context, listen: false)
        .orderStatus
        .forEach((OrderStatus _orderStatus) {
      _orderStatusSteps.add(
        Step(
            state: StepState.complete,
            title: Text(
              _orderStatus.status,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            subtitle: widget.order.orderStatus.id == _orderStatus.id
                ? Text(
                    DateFormat('HH:mm | yyyy-MM-dd').format(widget.order.dateTime),
                    style: Theme.of(context).textTheme.caption,
                    overflow: TextOverflow.ellipsis,
                  )
                : SizedBox(height: 0),
            content: SizedBox(
                width: double.infinity,
                child: Text(
                  Helper.skipHtml(widget.order.hint),
                )),
            isActive: (int.tryParse(widget.order.orderStatus.id))! >=
                (int.tryParse(_orderStatus.id)!)),
      );
    });
    if (!widget.order.active) {
      _orderStatusSteps = _orderStatusSteps.sublist(0, 1);
      _orderStatusSteps.add(Step(
          state: StepState.complete,
          title: Text(
            _trans.canceled,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          content: SizedBox(
              width: double.infinity,
              child: Text(
                Helper.skipHtml(widget.order.hint),
              )),
          isActive: true));
    }
    return _orderStatusSteps;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
