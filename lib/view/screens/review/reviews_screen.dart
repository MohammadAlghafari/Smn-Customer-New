import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/view_models/review_view_model.dart';

class ReviewsScreen extends StatefulWidget {
  Order order;

  ReviewsScreen({Key? key, required this.order}) : super(key: key);

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  late AppLocalizations _trans;

  @override
  void initState() {
    Provider.of<ReviewViewModel>(context, listen: false).init(widget.order);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
        body: RefreshIndicator(
            onRefresh: () async {
              // _con.refreshOrder
            },
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: Hero(
                                tag: 'restaurant_reviews' +
                                    widget
                                        .order.foodOrders[0].food.restaurant.id,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: widget.order.foodOrders[0].food
                                      .restaurant.image.url!,
                                  placeholder: (context, url) => Image.asset(
                                    'assets/img/loading.gif',
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: 110,
                            child: Chip(
                              padding: EdgeInsets.all(10),
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                      widget.order.foodOrders[0].food.restaurant
                                          .rate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .merge(TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor))),
                                  Icon(
                                    Icons.star_border,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                ],
                              ),
                              backgroundColor: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              shape: StadiumBorder(),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 30,
                        left: 15,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.order.foodOrders[0].food.restaurant.name,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Consumer<ReviewViewModel>(
                    builder: (context, reviewModel, child) {
                      return Column(
                        children: [
                          reviewModel.isRestaurantReview
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 30, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Theme.of(context)
                                                .focusColor
                                                .withOpacity(0.15),
                                            offset: Offset(0, -2),
                                            blurRadius: 5.0)
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                          _trans
                                              .how_would_you_rate_this_restaurant_,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(5, (index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                reviewModel
                                                        .restaurantReview.rate =
                                                    (index + 1).toString();
                                              });
                                            },
                                            child: index <
                                                    int.parse(reviewModel
                                                        .restaurantReview.rate)
                                                ? Icon(Icons.star,
                                                    size: 40,
                                                    color: Color(0xFFFFB24D))
                                                : Icon(Icons.star_border,
                                                    size: 40,
                                                    color: Color(0xFFFFB24D)),
                                          );
                                        }),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        onChanged: (text) {
                                          reviewModel.restaurantReview.review =
                                              text;
                                        },
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(12),
                                          hintText: _trans
                                              .tell_us_about_this_restaurant,
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .merge(TextStyle(fontSize: 14)),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .focusColor
                                                      .withOpacity(0.1))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .focusColor
                                                      .withOpacity(0.2))),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .focusColor
                                                      .withOpacity(0.1))),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      FlatButton.icon(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 18),
                                        onPressed: () {
                                          Provider.of<ReviewViewModel>(context,
                                                  listen: false)
                                              .addRestaurantReview(
                                                  reviewModel.restaurantReview,
                                                  widget.order.foodOrders[0]
                                                      .food.restaurant);
                                          FocusScope.of(context).unfocus();
                                        },
                                        shape: StadiumBorder(),
                                        label: Text(
                                          _trans.submit,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        icon: Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        textColor:
                                            Theme.of(context).primaryColor,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          Column(
                            children: List.generate(
                                reviewModel.foodsOfOrder.length, (index) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                padding: EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Theme.of(context)
                                              .focusColor
                                              .withOpacity(0.15),
                                          offset: Offset(0, -2),
                                          blurRadius: 5.0)
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(reviewModel.foodsOfOrder[index].name,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(5, (star) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              reviewModel.foodsReviews[index]
                                                  .rate = (star + 1).toString();
                                            });
                                          },
                                          child: star <
                                                  int.parse(reviewModel
                                                      .foodsReviews[index].rate)
                                              ? Icon(Icons.star,
                                                  size: 40,
                                                  color: Color(0xFFFFB24D))
                                              : Icon(Icons.star_border,
                                                  size: 40,
                                                  color: Color(0xFFFFB24D)),
                                        );
                                      }),
                                    ),
                                    SizedBox(height: 10),
                                    TextField(
                                      onChanged: (text) {
                                        reviewModel.foodsReviews[index].review =
                                            text;
                                      },
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(12),
                                        hintText:
                                            _trans.tell_us_about_this_food,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .merge(TextStyle(fontSize: 14)),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(0.1))),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(0.2))),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .focusColor
                                                    .withOpacity(0.1))),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    FlatButton.icon(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 18),
                                      onPressed: () {
                                        Provider.of<ReviewViewModel>(context,
                                                listen: false)
                                            .addFoodReview(index);
                                        FocusScope.of(context).unfocus();
                                      },
                                      shape: StadiumBorder(),
                                      label: Text(
                                        _trans.submit,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      icon: Icon(
                                        Icons.check,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      textColor: Theme.of(context).primaryColor,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )));
  }
}
