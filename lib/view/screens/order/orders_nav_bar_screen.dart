import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view/screens/order/widget/EmptyOrdersWidget.dart';
import 'package:smn_delivery_app/view/screens/order/widget/OrderItemWidget.dart';
import 'package:smn_delivery_app/view/customWidget/PermissionDeniedWidget.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/order_view_model.dart';

class OrderNavBarScreen extends StatefulWidget {
  const OrderNavBarScreen({Key? key}) : super(key: key);

  @override
  _OrderNavBarScreenState createState() => _OrderNavBarScreenState();
}

class _OrderNavBarScreenState extends State<OrderNavBarScreen> {
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          tooltip: _trans.menu,
          icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.my_orders,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Consumer2<OrderViewModel, AuthViewModel>(
        builder: (context, orderModel, authModel, child) {
          if (authModel.user == null) {
            return PermissionDeniedWidget();
          }
          // if (orderModel.orders.isEmpty) return EmptyOrdersWidget();
          return RefreshIndicator(
            onRefresh: orderModel.refreshOrders,
            child: orderModel.orders.isEmpty
                ? SingleChildScrollView(
                    child: EmptyOrdersWidget(),
                    physics: const AlwaysScrollableScrollPhysics(),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        /* Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SearchBarWidget(),
                        ), */
                        SizedBox(height: 20),
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: orderModel.orders.length,
                          itemBuilder: (context, index) {
                            var _order = orderModel.orders.elementAt(index);
                            return OrderItemWidget(
                              expanded: index == 0 ? true : false,
                              order: _order,
                              onCanceled: (e) {
                                orderModel.doCancelOrder(_order);
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20);
                          },
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
