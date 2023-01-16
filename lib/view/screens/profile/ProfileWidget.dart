import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/view_models/order_view_model.dart';
import '../order/widget/EmptyOrdersWidget.dart';
import '../order/widget/OrderItemWidget.dart';
import '../../customWidget/PermissionDeniedWidget.dart';
import 'widget/ProfileAvatarWidget.dart';
import '../../customWidget/drawer_widget.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.sort, color: Theme.of(context).primaryColor),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.profile,
          style: Theme.of(context).textTheme.headline6!.merge(TextStyle(
              letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShoppingCartButtonWidget(
              background: Theme.of(context).accentColor,
                iconColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).hintColor),
          ),
        ],
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authModel, child) {
          if (authModel.user == null) return PermissionDeniedWidget();
          return SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Column(
              children: <Widget>[
                ProfileAvatarWidget(user: authModel.user!),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Icon(
                    Icons.person,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    _trans.about,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    authModel.user?.bio ?? "",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Icon(
                    Icons.shopping_basket,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                    _trans.recent_orders,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                Consumer<OrderViewModel>(builder: (context, orderModel, child) {
                 if(orderModel.orders.isEmpty) return EmptyOrdersWidget();
                 return ListView.separated(
                   scrollDirection: Axis.vertical,
                   shrinkWrap: true,
                   primary: false,
                   itemCount: orderModel.orders.length>3?3:orderModel.orders.length,
                   itemBuilder: (context, index) {
                     var _order =  orderModel.orders.elementAt(index);
                     return OrderItemWidget(
                       expanded: index == 0 ? true : false,
                       order: _order, onCanceled: (void value) {  },);
                   },
                   separatorBuilder: (context, index) {
                     return SizedBox(height: 20);
                   },
                 );
                },)

              ],
            ),
          );
        },
      ),
    );
  }
}
