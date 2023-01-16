import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/AddToCartAlertDialogWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view/screens/review/widget/ReviewsListWidget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';
import 'package:smn_delivery_app/view_models/favorite_view_model.dart';

import 'widget/ExtraItemWidget.dart';

class FoodDetailsScreen extends StatefulWidget {
  Food food;

  FoodDetailsScreen({Key? key, required this.food}) : super(key: key);

  @override
  _FoodDetailsScreenState createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late AppLocalizations _trans;
  double quantity = 1;

  @override
  void initState() {
    Provider.of<FavoriteViewModel>(context, listen: false)
        .listenForFavorite(foodId: widget.food.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 125),
            padding: const EdgeInsets.only(bottom: 15),
            child: CustomScrollView(
              primary: true,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor:
                  Theme
                      .of(context)
                      .accentColor
                      .withOpacity(0.9),
                  expandedHeight: 300,
                  elevation: 0,
                  iconTheme:
                  IconThemeData(color: Theme
                      .of(context)
                      .primaryColor),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Hero(
                      tag: widget.food.id,
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.food.image.url!,
                        placeholder: (context, url) =>
                            Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                            ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Wrap(
                      runSpacing: 8,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.food.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .headline3,
                                  ),
                                  Text(
                                    widget.food.restaurant.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  widget.food.discountPrice > 0
                                      ? Helper.getPrice(
                                    widget.food.discountPrice,
                                    context,
                                    style:
                                    Theme.of(context).textTheme.headline4,
                                  )
                                      : const SizedBox(height: 0),
                                  Helper.getPrice(
                                      widget.food.price, context,
                                      style: widget.food.discountPrice > 0
                                          ? Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .merge(const TextStyle(
                                          decoration:
                                          TextDecoration.lineThrough))
                                          : Theme.of(context).textTheme.headline4),

                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 3),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(24)),
                              child: Text(
                                _trans.deliverable,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .caption!
                                    .merge(TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor)),
                              ),
                            ),
                            const Expanded(child: SizedBox(height: 0)),
                            widget.food.weight.isNotEmpty && widget.food
                                .weight != '0' ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .focusColor,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  widget.food.weight + " " + widget.food.unit,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .caption!
                                      .merge(TextStyle(
                                      color:
                                      Theme
                                          .of(context)
                                          .primaryColor)),
                                  overflow: TextOverflow.ellipsis,
                                )) : Container(),
                            const SizedBox(width: 5),
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Theme
                                        .of(context)
                                        .focusColor,
                                    borderRadius: BorderRadius.circular(24)),
                                child: Text(
                                  widget.food.packageItemsCount +
                                      " " +
                                      _trans.items,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .caption!
                                      .merge(TextStyle(
                                      color:
                                      Theme
                                          .of(context)
                                          .primaryColor)),
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ],
                        ),
                        const Divider(height: 20),
                        Helper.applyHtml(context, widget.food.description,
                            style: const TextStyle(fontSize: 12)),
                        widget.food.extraGroups.isEmpty
                            ? Container()
                            : ListTile(
                          dense: true,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                          leading: Icon(
                            Icons.add_circle,
                            color: Theme
                                .of(context)
                                .hintColor,
                          ),
                          title: Text(
                            _trans.extras,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1,
                          ),
                          subtitle: Text(
                            _trans.select_extras_to_add_them_on_the_food,
                            style: Theme
                                .of(context)
                                .textTheme
                                .caption,
                          ),
                        ),
                        ListView.separated(
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, extraGroupIndex) {
                            var extraGroup = widget.food.extraGroups
                                .elementAt(extraGroupIndex);
                            return Wrap(
                              children: <Widget>[
                                ListTile(
                                  dense: true,
                                  contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                                  leading: Icon(
                                    Icons.add_circle_outline,
                                    color: Theme
                                        .of(context)
                                        .hintColor,
                                  ),
                                  title: Text(
                                    extraGroup.name,
                                    style:
                                    Theme
                                        .of(context)
                                        .textTheme
                                        .subtitle1,
                                  ),
                                ),
                                ListView.separated(
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (context, extraIndex) {
                                    return ExtraItemWidget(
                                      extra: widget.food.extras
                                          .where((extra) =>
                                      extra.extraGroupId ==
                                          extraGroup.id)
                                          .elementAt(extraIndex),
                                      // onChanged: _con.calculateTotal,
                                      onChanged: () {},
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 20);
                                  },
                                  itemCount: widget.food.extras
                                      .where((extra) =>
                                  extra.extraGroupId == extraGroup.id)
                                      .length,
                                  primary: false,
                                  shrinkWrap: true,
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20);
                          },
                          itemCount: widget.food.extraGroups.length,
                          primary: false,
                          shrinkWrap: true,
                        ),
                        widget.food.ingredients.isEmpty
                            ? Container()
                            : ListTile(
                          dense: true,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                          leading: Icon(
                            Icons.donut_small,
                            color: Theme
                                .of(context)
                                .hintColor,
                          ),
                          title: Text(
                            _trans.ingredients,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1,
                          ),
                        ),
                        Helper.applyHtml(context, widget.food.ingredients,
                            style: const TextStyle(fontSize: 12)),
                        widget.food.nutritions.isEmpty
                            ? Container()
                            : ListTile(
                          dense: true,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                          leading: Icon(
                            Icons.local_activity,
                            color: Theme
                                .of(context)
                                .hintColor,
                          ),
                          title: Text(
                            _trans.nutrition,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1,
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(widget.food.nutritions.length,
                                  (index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme
                                                .of(context)
                                                .focusColor
                                                .withOpacity(0.2),
                                            offset: const Offset(0, 2),
                                            blurRadius: 6.0)
                                      ]),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                          widget.food.nutritions
                                              .elementAt(index)
                                              .name,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .caption),
                                      Text(
                                          widget.food.nutritions
                                              .elementAt(index)
                                              .quantity
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline5),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        widget.food.foodReviews.isEmpty
                            ? Container()
                            : ListTile(
                          dense: true,
                          contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                          leading: Icon(
                            Icons.recent_actors,
                            color: Theme
                                .of(context)
                                .hintColor,
                          ),
                          title: Text(
                            _trans.reviews,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1,
                          ),
                        ),
                        ReviewsListWidget(
                          reviewsList: widget.food.foodReviews,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
              top: 32,
              end: 20,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(

                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],),
                child: ShoppingCartButtonWidget(
                  iconColor: Theme
                      .of(context)
                      .hintColor,
                  labelColor: Theme
                      .of(context)
                      .accentColor,
                ),
              ),

          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: const Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Theme
                            .of(context)
                            .focusColor
                            .withOpacity(0.15),
                        offset: const Offset(0, -2),
                        blurRadius: 5.0)
                  ]),
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            _trans.quantity,
                            style: Theme
                                .of(context)
                                .textTheme
                                .subtitle1,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                // cartModel.decrementQuantity();
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                  }
                                });
                              },
                              iconSize: 30,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Theme
                                  .of(context)
                                  .hintColor,
                            ),
                            Text(quantity.toInt().toString(),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .subtitle1),
                            IconButton(
                              onPressed: () {
                                // cartModel.incrementQuantity();
                                // Provider
                                setState(() {
                                  quantity++;
                                });
                              },
                              iconSize: 30,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              icon: const Icon(Icons.add_circle_outline),
                              color: Theme
                                  .of(context)
                                  .hintColor,
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Consumer<AuthViewModel>(
                      builder: (context, authModel, child) {
                        return Row(
                          children: <Widget>[
                            Consumer<FavoriteViewModel>(
                              builder: (context, favoriteModel, child) {
                                return Expanded(
                                  child: widget.food.isFavorite
                                      ? OutlineButton(
                                      onPressed: () {
                                        if (authModel.user == null) {
                                          Navigator.of(context)
                                              .pushNamed("LoginScreen");
                                        } else {
                                          Provider.of<FavoriteViewModel>(
                                              context,
                                              listen: false)
                                              .addToFavorite(widget.food);
                                          setState(() {
                                            widget.food.isFavorite = false;
                                          });
                                        }
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      color: Theme
                                          .of(context)
                                          .primaryColor,
                                      shape: const StadiumBorder(),
                                      borderSide: BorderSide(
                                          color: Theme
                                              .of(context)
                                              .accentColor),
                                      child: Icon(
                                        Icons.favorite,
                                        color:
                                        Theme
                                            .of(context)
                                            .accentColor,
                                      ))
                                      : FlatButton(
                                      onPressed: () {
                                        if (authModel.user == null) {
                                          Navigator.of(context)
                                              .pushNamed("LoginScreen");
                                        } else {
                                          Provider.of<FavoriteViewModel>(
                                              context,
                                              listen: false)
                                              .removeFavorite();
                                          setState(() {
                                            widget.food.isFavorite = true;
                                          });
                                        }
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      color: Theme
                                          .of(context)
                                          .accentColor,
                                      shape: const StadiumBorder(),
                                      child: Icon(
                                        Icons.favorite,
                                        color:
                                        Theme
                                            .of(context)
                                            .primaryColor,
                                      )),
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Stack(
                              fit: StackFit.loose,
                              alignment: AlignmentDirectional.centerEnd,
                              children: <Widget>[
                                SizedBox(
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width - 110,
                                  child: FlatButton(
                                    onPressed: () {
                                      if (authModel.user == null) {
                                        Navigator.of(context)
                                            .pushNamed("LoginScreen");
                                      } else {
                                        //buildShowDialog(context);
                                        if (Provider.of<CartViewModel>(context,
                                            listen: false)
                                            .isSameRestaurants(widget.food)) {
                                          Provider.of<CartViewModel>(context,
                                              listen: false)
                                              .addToCart(widget.food, quantity,
                                              context);
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // return object of type Dialog
                                              return AddToCartAlertDialogWidget(
                                                  oldFood: Provider
                                                      .of<
                                                      CartViewModel>(
                                                      context,
                                                      listen: false)
                                                      .cartItems
                                                      .elementAt(0)
                                                      .food,
                                                  newFood: widget.food,
                                                  onPressed: (food,
                                                      {reset = true}) {
                                                     Provider.of<
                                                        CartViewModel>(
                                                        context,
                                                        listen: false)
                                                        .addToCart(widget.food,
                                                        quantity, context,
                                                        reset: reset,foodDetails:true);

                                                  });
                                            },
                                          );
                                        }
                                      }
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    color: Theme
                                        .of(context)
                                        .accentColor,
                                    shape: const StadiumBorder(),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _trans.add_to_cart,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor),
                                          ),
                                          Helper.getPrice(
                                            (quantity *widget.food.discountPrice>0?widget.food.discountPrice: widget.food.price),
                                            context,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headline4!
                                                .merge(TextStyle(
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
