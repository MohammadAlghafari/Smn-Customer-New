import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/utili/maps_util.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodItemWidget.dart';
import 'package:smn_delivery_app/view/screens/restaurant/widget/ImageThumbCarouselWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view/screens/review/widget/ReviewsListWidget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/restaurants_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class RestaurantDetailsNavBarScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailsNavBarScreen({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RestaurantDetailsNavBarScreenState createState() =>
      _RestaurantDetailsNavBarScreenState();
}

class _RestaurantDetailsNavBarScreenState
    extends State<RestaurantDetailsNavBarScreen> {
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // Provider.of<RestaurantsViewModel>(context, listen: false)
    //     .init(widget.restaurantId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: Icon(Icons.sort, color: Theme.of(context).hintColor),
        //     onPressed: () => scaffoldKey.currentState!.openDrawer(),
        //   ),
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   centerTitle: true,
        //   title: Image.asset('assets/img/SMN_final_logo_small.png',
        //       width: 50, height: 50),
        //   actions: <Widget>[
        //     ShoppingCartButtonWidget(
        //         iconColor: Theme.of(context).hintColor,
        //         labelColor: Theme.of(context).accentColor),
        //   ],
        // ),
        key: scaffoldKey,
        body: Consumer<RestaurantsViewModel>(
          builder: (context, restaurantModel, child) {
            return RefreshIndicator(
              onRefresh: restaurantModel.refreshRestaurant,
              child: restaurantModel.isLoadingRestaurant()
                  ? CircularLoadingWidget(height: 500)
                  : Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CustomScrollView(
                          primary: true,
                          shrinkWrap: false,
                          slivers: <Widget>[
                            SliverAppBar(
                              backgroundColor: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.9),
                              expandedHeight: 300,
                              elevation: 0,
//                          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                              automaticallyImplyLeading: false,
                              leading: IconButton(
                                tooltip: _trans.back,
                                icon: Icon(
                                    Platform.isAndroid
                                        ? Icons.arrow_back
                                        : Icons.arrow_back_ios,
                                    color: Theme.of(context).primaryColor),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              flexibleSpace: FlexibleSpaceBar(
                                collapseMode: CollapseMode.parallax,
                                background: Hero(
                                  tag: DateTime.now().toString(),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        restaurantModel.restaurant!.image.url!,
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
                            SliverToBoxAdapter(
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20,
                                        left: 20,
                                        bottom: 10,
                                        top: 25),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          restaurantModel.restaurant?.name ??
                                              '',
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          maxLines: 2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
                                        ),const SizedBox(width: 10,),
                                        if (restaurantModel.restaurant!.hasLicense)
                                         const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                         ),
                                         Expanded(child: Container(),),
                                        SizedBox(
                                          height: 32,
                                          child: Chip(
                                            padding: EdgeInsets.all(0),
                                            label: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                    restaurantModel
                                                            .restaurant?.rate ??
                                                        "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .merge(TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor))),
                                                Icon(
                                                  Icons.star_border,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 16,
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
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(width: 20),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: restaurantModel
                                                    .restaurant!.closed
                                                ? Colors.grey
                                                : Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        child: restaurantModel
                                                .restaurant!.closed
                                            ? Text(
                                                _trans.closed,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              )
                                            : Text(
                                                _trans.open,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              ),
                                      ),
                                      SizedBox(width: 10),
                                      /* Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 3),
                                        decoration: BoxDecoration(
                                            color: restaurantModel
                                                    .restaurant!.hasLicense
                                                ? Colors.green
                                                : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(24)),
                                        child: restaurantModel
                                                .restaurant!.hasLicense
                                            ? Text(
                                                _trans.licensed,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              )
                                            : Text(
                                                _trans.not_licensed,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .merge(TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColor)),
                                              ),
                                      ),
                                      SizedBox(width: 10), */
                                      Expanded(child: SizedBox(height: 0)),
                                      // Consumer2<SettingViewModel,
                                      //     AuthViewModel>(
                                      //   builder: (context, settingModel,
                                      //       authModel, child) {
                                      //     return Container(
                                      //       padding: EdgeInsets.symmetric(
                                      //           horizontal: 12, vertical: 3),
                                      //       decoration: BoxDecoration(
                                      //           color: Helper.canDelivery(
                                      //                   restaurantModel
                                      //                       .restaurant!,
                                      //                   authModel
                                      //                       .deliveryAddress,
                                      //                   settingModel.setting)
                                      //               ? Colors.green
                                      //               : Colors.grey,
                                      //           borderRadius:
                                      //               BorderRadius.circular(24)),
                                      //       child: Text(
                                      //         Helper.getDistance(
                                      //             restaurantModel
                                      //                 .restaurant!.distance,
                                      //             Helper().trans(settingModel
                                      //                 .setting.distanceUnit),
                                      //             settingModel
                                      //                 .setting.distanceUnit),
                                      //         style: Theme.of(context)
                                      //             .textTheme
                                      //             .caption!
                                      //             .merge(TextStyle(
                                      //                 color: Theme.of(context)
                                      //                     .primaryColor)),
                                      //       ),
                                      //     );
                                      //   },
                                      // ),
                                      SizedBox(width: 20),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 12,
                                      bottom: 12,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          _trans.avg_preparing_time,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          restaurantModel.restaurant!.avgTime +
                                              ' ' +
                                              _trans.hrs,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    child: Helper.applyHtml(
                                        context,
                                        restaurantModel
                                            .restaurant!.description),
                                  ),
                                  ImageThumbCarouselWidget(
                                      galleriesList: restaurantModel.galleries),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      color: Theme.of(context).primaryColor,
                                      child: Consumer<AuthViewModel>(
                                        builder: (context, authModel, child) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  authModel.user?.apiToken !=
                                                          null
                                                      ? _trans
                                                          .forMoreDetailsPleaseChatWithOurManagers
                                                      : _trans
                                                          .signinToChatWithOurManagers,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              SizedBox(
                                                width: 42,
                                                height: 42,
                                                child: FlatButton(
                                                  padding: EdgeInsets.all(0),
                                                  disabledColor:
                                                      Theme.of(context)
                                                          .focusColor
                                                          .withOpacity(0.5),
                                                  onPressed: () async {
/*

                                                    List<String>chatOwners = [];
                                                            for (int i = 0;
                                                                i <
                                                                    restaurantModel
                                                                        .restaurant!
                                                                        .users
                                                                        .length;
                                                                i++) {
                                                              chatOwners.add(
                                                                  restaurantModel
                                                                      .restaurant!
                                                                      .users[i]
                                                                      .id!);
                                                            }

                                                            chatOwners.add(
                                                                authModel
                                                                    .user!.id!);
                                                            List<User> users =
                                                                restaurantModel
                                                                    .restaurant!
                                                                    .users
                                                                    .map((e) {
                                                              e.image =
                                                                  restaurantModel
                                                                      .restaurant!
                                                                      .image;
                                                              return e;
                                                            }).toList();
                                                            users.add(
                                                                authModel.user!);
                                                    var id = await Provider.of<MessagesViewModel>(context, listen: false)
                                                        .getConversation(chatOwners);
                                                    Navigator.of(context).pushNamed(
                                                      'ChatScreen',
                                                      arguments: {
                                                        'Conversation': Conversation.fromJSON({
                                                          'users':users,
                                                          'name': restaurantModel.restaurant!.name,
                                                          'id': id,
                                                        }),
                                                        'restaurantId': restaurantModel.restaurant!.id
                                                      },
                                                    );

 */
                                                    if (authModel.user ==
                                                        null) {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              "LoginScreen");
                                                    } else {
                                                      Navigator.pushNamed(
                                                          context,
                                                          "ChatRestaurantNavBarScreen",
                                                          arguments: widget
                                                              .restaurantId);
                                                    }
                                                  },
                                                  child: Icon(
                                                    Icons.chat,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 24,
                                                  ),
                                                  color: Theme.of(context)
                                                      .accentColor
                                                      .withOpacity(0.9),
                                                  shape: StadiumBorder(),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      )),

                                  /*
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    color: Theme.of(context).primaryColor,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            restaurantModel.restaurant!.address,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),

                                        //direction
                                        SizedBox(width: 10),
                                        SizedBox(
                                          width: 42,
                                          height: 42,
                                          child: FlatButton(
                                            padding: EdgeInsets.all(0),
                                            onPressed: () {
                                              MapsUtil.openMap(
                                                  restaurantModel
                                                      .restaurant!.latitude,
                                                  restaurantModel
                                                      .restaurant!.longitude);
                                            },
                                            child: Icon(
                                              Icons.directions,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              size: 24,
                                            ),
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.9),
                                            shape: StadiumBorder(),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                  */
                                  // Container(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 20, vertical: 20),
                                  //   margin:
                                  //       const EdgeInsets.symmetric(vertical: 5),
                                  //   color: Theme.of(context).primaryColor,
                                  //   child: Row(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: <Widget>[
                                  //       Expanded(
                                  //         child: Text(
                                  //           restaurantModel
                                  //                       .restaurant!.mobile !=
                                  //                   null
                                  //               ? '${restaurantModel.restaurant!.phone!} \n${restaurantModel.restaurant!.mobile!}'
                                  //               : restaurantModel
                                  //                   .restaurant!.phone!,
                                  //           overflow: TextOverflow.ellipsis,
                                  //           style: Theme.of(context)
                                  //               .textTheme
                                  //               .bodyText1,
                                  //         ),
                                  //       ),
                                  //       SizedBox(width: 10),
                                  //       SizedBox(
                                  //         width: 42,
                                  //         height: 42,
                                  //         child: FlatButton(
                                  //           padding: EdgeInsets.all(0),
                                  //           onPressed: () {
                                  //             if (restaurantModel
                                  //                     .restaurant!.mobile !=
                                  //                 null) {
                                  //               launch(
                                  //                   "tel:${restaurantModel.restaurant!.mobile}");
                                  //             } else {
                                  //               launch(
                                  //                   "tel:${restaurantModel.restaurant!.phone}");
                                  //             }
                                  //           },
                                  //           child: Icon(
                                  //             Icons.call,
                                  //             color: Theme.of(context)
                                  //                 .primaryColor,
                                  //             size: 24,
                                  //           ),
                                  //           color: Theme.of(context)
                                  //               .accentColor
                                  //               .withOpacity(0.9),
                                  //           shape: StadiumBorder(),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  restaurantModel.featuredFoods.isEmpty
                                      ? SizedBox(height: 0)
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: ListTile(
                                            dense: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0),
                                            leading: Icon(
                                              Icons.restaurant,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                            title: Text(
                                              _trans.featured_foods,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                          ),
                                        ),
                                  restaurantModel.featuredFoods.isEmpty
                                      ? SizedBox(height: 0)
                                      : ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          primary: false,
                                          itemCount: restaurantModel
                                              .featuredFoods.length,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(height: 10);
                                          },
                                          itemBuilder: (context, index) {
                                            return FoodItemWidget(
                                              heroTag: 'details_featured_food',
                                              food: restaurantModel
                                                  .featuredFoods
                                                  .elementAt(index),
                                            );
                                          },
                                        ),
                                  SizedBox(height: 100),
                                  restaurantModel.reviews.isEmpty
                                      ? SizedBox(height: 5)
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: ListTile(
                                            dense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0),
                                            leading: Icon(
                                              Icons.recent_actors,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                            title: Text(
                                              _trans.what_they_say,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                          ),
                                        ),
                                  restaurantModel.reviews.isEmpty
                                      ? SizedBox(height: 5)
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: ReviewsListWidget(
                                              reviewsList:
                                                  restaurantModel.reviews),
                                        ),
                                ],
                              ),
                            ),
                          ],
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
                              iconColor: Theme.of(context).hintColor,
                              labelColor: Theme.of(context).accentColor,
                            ),
                          ),
                        ),

                        // Positioned(
                        //   top: 32,
                        //   right: 20,
                        //   child: ShoppingCartFloatButtonWidget(
                        //       iconColor: Theme.of(context).primaryColor,
                        //       labelColor: Theme.of(context).hintColor,
                        //       routeArgument: RouteArgument(
                        //           id: '0',
                        //           param: restaurantModel.restaurant!.id,
                        //           heroTag: 'home_slide')),
                        // ),
                      ],
                    ),
            );
          },
        ));
  }
}
