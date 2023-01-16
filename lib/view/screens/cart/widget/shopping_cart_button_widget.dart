import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingCartButtonWidget extends StatefulWidget {
  final Color iconColor;
  final Color labelColor;
   Color ?background;

   ShoppingCartButtonWidget(
      {Key? key, required this.iconColor, required this.labelColor,this.background})
      : super(key: key);

  @override
  _ShoppingCartButtonWidgetState createState() =>
      _ShoppingCartButtonWidgetState();
}

class _ShoppingCartButtonWidgetState extends State<ShoppingCartButtonWidget> {
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return SizedBox(
      width: 60,
      height: 60,
      child: Consumer<AuthViewModel>(
        builder: (context, authModel, child) {
          return Tooltip(
            message: _trans.cart,
            child: RaisedButton(
              elevation: 0,
              highlightElevation: 0,
              highlightColor: Colors.white,
              splashColor: Colors.white,
              shape: StadiumBorder(),
              color: widget.background ?? Theme.of(context).scaffoldBackgroundColor,
              onPressed: () {
                if (authModel.user == null) {
                  Navigator.of(context).pushNamed('LoginScreen');
                } else {
                  Navigator.of(context).pushNamed('CartScreen');
                }
              },

              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 28,
                    color: widget.iconColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Container(
                      child: Consumer<CartViewModel>(
                        builder: (context, cartModel, child) {
                          return Text(
                            cartModel.cartItems.length.toString(),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.caption!.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 10),
                                ),
                          );
                        },
                      ),
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                          color: widget.labelColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      constraints: const BoxConstraints(
                          minWidth: 15, minHeight: 15, maxHeight: 15),
                    ),
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
