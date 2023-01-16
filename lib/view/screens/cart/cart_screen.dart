import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/CartBottomDetailsWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/CartItemWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/EmptyCartWidget.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late AppLocalizations _trans;
  final TextEditingController coupon = TextEditingController();

  @override
  void initState() {
    Provider.of<CartViewModel>(context,listen: false).coupon=null;

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) =>  Provider.of<CartViewModel>(context,listen: false).calculateSubtotal());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      // bottomNavigationBar: CartBottomDetailsWidget(con: _con),
      appBar: AppBar(
        leading: IconButton(
          tooltip: _trans.back,
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).accentColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.cart,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Consumer<CartViewModel>(
        builder: (context, cartModel, child) {
          return RefreshIndicator(
            onRefresh: cartModel.refreshCarts,
            child: cartModel.cartItems.isEmpty
                ? EmptyCartWidget()
                : Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      ListView(
                        primary: true,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                              leading: Icon(
                                Icons.shopping_cart,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                _trans.shopping_cart,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                _trans.verify_your_quantity_and_click_checkout,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ),
                          ListView.separated(
                            padding:
                                const EdgeInsets.only(top: 15, bottom: 120),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: cartModel.cartItems.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 15);
                            },
                            itemBuilder: (context, index) {
                              return CartItemWidget(
                                cart: cartModel.cartItems.elementAt(index),
                                heroTag: 'cart',
                                increment: () {
                                  cartModel.incrementQuantity(
                                      cartModel.cartItems.elementAt(index));
                                },
                                decrement: () {
                                  cartModel.decrementQuantity(
                                      cartModel.cartItems.elementAt(index));
                                },
                                onDismissed: () {
                                  cartModel.removeFromCart(
                                      cartModel.cartItems.elementAt(index));
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,

                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.15),
                                  offset: const Offset(0, 2),
                                  blurRadius: 5.0)
                            ]),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          onSubmitted: (String value) {
                            cartModel.doApplyCoupon(value);
                          },
                          cursorColor: Theme.of(context).accentColor,
                          controller: coupon,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintStyle: Theme.of(context).textTheme.bodyText1,
                            suffixText: cartModel.coupon?.valid == null
                                ? ''
                                : (cartModel.coupon!.valid!
                                    ? _trans.validCouponCode
                                    : _trans.invalidCouponCode),
                            suffixStyle: Theme.of(context)
                                .textTheme
                                .caption!
                                .merge(TextStyle(
                                    color:
                                        cartModel.getCouponIconColor(context))),
                            suffixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: IconButton(
                                icon: Icon(
                                  Icons.confirmation_number,
                                  color: cartModel.getCouponIconColor(context),
                                  size: 28,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  cartModel.doApplyCoupon(coupon.text);
                                },
                              ),
                            ),
                            hintText: _trans.haveCouponCode,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.5))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Theme.of(context)
                                        .focusColor
                                        .withOpacity(0.2))),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),

      bottomNavigationBar: CartBottomDetailsWidget(),
    );
  }

}
