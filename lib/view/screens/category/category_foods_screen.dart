import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/AddToCartAlertDialogWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodGridItemWidget.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodListItemWidget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';
import 'package:smn_delivery_app/view_models/category_view_model.dart';

import '../../customWidget/loading_progress_indicator.dart';

class CategoryFoodsScreen extends StatefulWidget {
  Category category;

  CategoryFoodsScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryFoodsScreenState createState() => _CategoryFoodsScreenState();
}

class _CategoryFoodsScreenState extends State<CategoryFoodsScreen> {
  late AppLocalizations _trans;
  String layout = 'grid';

  @override
  void initState() {
    Provider.of<CategoryViewModel>(context, listen: false)
        .listenForFoodsByCategory(id: widget.category.id);
    // _con.listenForCategory(id: widget.categoryId);
    // _con.listenForCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      //drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          _trans.category,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 0)),
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: Consumer<CategoryViewModel>(
        builder: (context, categoryModel, child) {
          return SingleChildScrollView(
            controller: categoryModel.sc,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: SearchBarWidget(onClickFilter: (filter) {
                //     // _con.scaffoldKey?.currentState?.openEndDrawer();
                //   }),
                // ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        leading: Icon(
                          Icons.category,
                          color: Theme.of(context).hintColor,
                        ),
                        title: Text(
                          widget.category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  layout = 'list';
                                });
                              },
                              icon: Icon(
                                Icons.format_list_bulleted,
                                color: layout == 'list'
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).focusColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  layout = 'grid';
                                });
                              },
                              icon: Icon(
                                Icons.apps,
                                color: layout == 'grid'
                                    ? Theme.of(context).accentColor
                                    : Theme.of(context).focusColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                   Offstage(
                            offstage: layout != 'list',
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: categoryModel.foods.length,
                              separatorBuilder: (context, index) {
                                return const SizedBox(height: 10);
                              },
                              itemBuilder: (context, index) {
                                return FoodListItemWidget(
                                  heroTag: 'favorites_list'+ categoryModel.foods.elementAt(index).id,
                                  food: categoryModel.foods.elementAt(index),
                                );
                              },
                            ),
                          ),
                    Offstage(
                            offstage: layout != 'grid',
                            child: GridView.count(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              primary: false,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this produces 2 rows.
                              crossAxisCount:
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 2
                                      : 4,
                              // Generate 100 widgets that display their index in the List.
                              children: List.generate(
                                  categoryModel.foods.length, (index) {
                                return Consumer<AuthViewModel>(
                                  builder: (context, authModel, child) {
                                    return FoodGridItemWidget(
                                        heroTag: 'category_grid'+categoryModel.foods.elementAt(index).id,
                                        food: categoryModel.foods
                                            .elementAt(index),
                                        onPressed: () {
                                          if (authModel.user == null) {
                                            Navigator.of(context)
                                                .pushNamed('LoginScreen');
                                          } else {
                                            // buildShowDialog(context);
                                            // Provider.of<CartViewModel>(context,listen: false).addToCart(categoryModel.foods.elementAt(index), 1, context);
                                            /*
                                          if (_con.isSameRestaurants(_con.foods.elementAt(index))) {
                                            _con.addToCart(_con.foods.elementAt(index));
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AddToCartAlertDialogWidget(
                                                    oldFood: _con.carts.elementAt(0)?.food,
                                                    newFood: _con.foods.elementAt(index),
                                                    onPressed: (food, {reset: true}) {
                                                      return _con.addToCart(_con.foods.elementAt(index), reset: true);
                                                    });
                                              },
                                            );
                                          }
                                           */

                                            //buildShowDialog(context);
                                            if (Provider.of<CartViewModel>(
                                                    context,
                                                    listen: false)
                                                .isSameRestaurants(categoryModel
                                                    .foods
                                                    .elementAt(index))) {
                                              Provider.of<CartViewModel>(
                                                      context,
                                                      listen: false)
                                                  .addToCart(
                                                      categoryModel.foods
                                                          .elementAt(index),
                                                      1,
                                                      context,doPop: false);
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  // return object of type Dialog
                                                  return AddToCartAlertDialogWidget(
                                                      oldFood: Provider.of<
                                                                  CartViewModel>(
                                                              context,
                                                              listen: false)
                                                          .cartItems
                                                          .elementAt(0)
                                                          .food,
                                                      newFood: categoryModel
                                                          .foods
                                                          .elementAt(index),
                                                      onPressed: (food,
                                                          {reset = true}) {
                                                        return Provider.of<
                                                                    CartViewModel>(
                                                                context,
                                                                listen: false)
                                                            .addToCart(
                                                                categoryModel
                                                                    .foods
                                                                    .elementAt(
                                                                        index),
                                                                1,
                                                                context,
                                                                reset: reset);
                                                      });
                                                },
                                              );
                                            }
                                          }
                                        });
                                  },
                                );
                              }),
                            ),
                          ),
                    if(categoryModel.isLoading)
                    _buildProgressIndicator(),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const Padding(
      padding:  EdgeInsets.all(8.0),
      child: Center(
        child:  LoadingProgressIndicator(),
      ),
    );
  }
}
