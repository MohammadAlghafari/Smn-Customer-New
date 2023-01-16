import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/myColors.dart';
import 'package:smn_delivery_app/view/screens/restaurant/widget/CardsCarouselWidget.dart';
import 'package:smn_delivery_app/view/screens/category/widget/CategoriesCarouselWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/DeliveryAddressBottomSheetWidget.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodsCarouselWidget.dart';
import 'package:smn_delivery_app/view/screens/home/widget/GridWidget.dart';
import 'package:smn_delivery_app/view/screens/home/widget/HomeSliderWidget.dart';
import 'package:smn_delivery_app/view/customWidget/search/SearchBarWidget.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/customWidget/end_drawer.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view/screens/review/widget/ReviewsListWidget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/home_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class HomeNavBarScreen extends StatefulWidget {
  const HomeNavBarScreen({Key? key}) : super(key: key);

  @override
  _HomeNavBarScreenState createState() => _HomeNavBarScreenState();
}

class _HomeNavBarScreenState extends State<HomeNavBarScreen> {
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
        title: Image.asset('assets/img/SMN_final_logo_small.png',
            width: 50, height: 50),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      endDrawer: const EndDrawer(),
      drawer: const DrawerWidget(),
      body: Consumer<HomeViewModel>(
        builder: (context, homeModel, child) {
          return RefreshIndicator(
            onRefresh: homeModel.refreshHome,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Consumer2<SettingViewModel, AuthViewModel>(
                builder: (context, settingModel, authModel, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                        settingModel.setting.homeSections.length, (index) {
                      String _homeSection =
                          settingModel.setting.homeSections.elementAt(index);
                      switch (_homeSection) {
                        case 'slider':
                          return HomeSliderWidget(slides: homeModel.slides);
                        case 'search':
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SearchBarWidget(
                              onClickFilter: (event) {
                                scaffoldKey.currentState!.openEndDrawer();
                              },
                            ),
                          );
                        case 'top_restaurants_heading':
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 20, right: 20, bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //homeModel.nearByRestaurants.isEmpty?Container():
                                    Expanded(
                                      child: Text(
                                        _trans.top_restaurants,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (authModel.user == null ||
                                            authModel.user!.apiToken == null) {
                                          authModel.requestForCurrentLocation(
                                              context,
                                              settingModel
                                                  .setting.googleMapsKey);
                                        } else {
                                          var bottomSheetController =
                                              scaffoldKey.currentState!
                                                  .showBottomSheet(
                                            (context) =>
                                                const DeliveryAddressBottomSheetWidget(),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                            ),
                                          );
                                          bottomSheetController.closed
                                              .then((value) {
                                            homeModel.refreshHome();
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: authModel.deliveryAddress ==
                                                  null
                                              ? Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.1)
                                              : Theme.of(context).accentColor,
                                        ),
                                        child: Text(
                                          _trans.delivery,
                                          style: TextStyle(
                                              color: authModel
                                                          .deliveryAddress ==
                                                      null
                                                  ? Theme.of(context).hintColor
                                                  : Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 7),
                                    InkWell(
                                      onTap: () {
                                        authModel.pickup(context);
                                        homeModel.refreshHome();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: authModel.deliveryAddress !=
                                                  null
                                              ? Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.1)
                                              : Theme.of(context).accentColor,
                                        ),
                                        child: Text(
                                          _trans.pickup,
                                          style: TextStyle(
                                              color: authModel
                                                          .deliveryAddress !=
                                                      null
                                                  ? Theme.of(context).hintColor
                                                  : Theme.of(context)
                                                      .primaryColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      authModel.deliveryAddress != null
                                          ? Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(end: 15),
                                                child: Text(
                                                  _trans.near_to +
                                                      " " +
                                                      (authModel
                                                              .deliveryAddress!
                                                              .address ??
                                                          ""),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, 'AllRestaurantsScreen');
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Text(
                                                _trans.view_all,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize: 15),
                                              ),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              Icon(Icons.arrow_forward_ios,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary)
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        case 'top_restaurants':
                          return CardsCarouselWidget(
                              restaurantsList: homeModel.nearByRestaurants,
                              heroTag: 'home_top_restaurants');
                        case 'trending_week_heading':
                          return homeModel.trendingFoods.isEmpty
                              ? Container()
                              : ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  leading: Icon(
                                    Icons.trending_up,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  title: Text(
                                    _trans.trending_this_week,
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  subtitle: Text(
                                    _trans
                                        .clickOnTheFoodToGetMoreDetailsAboutIt,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                );
                        case 'trending_week':
                          return FoodsCarouselWidget(
                              foodsList: homeModel.trendingFoods,
                              heroTag: 'home_food_carousel');
                        case 'categories_heading':
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListTile(
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                              leading: Icon(
                                Icons.category,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                _trans.food_categories,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          );
                        case 'categories':
                          return CategoriesCarouselWidget(
                            categories: homeModel.categories,
                          );
                        case 'popular_heading':
                          return homeModel.popularRestaurants.isEmpty
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: ListTile(
                                    dense: true,
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    leading: Icon(
                                      Icons.trending_up,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    title: Text(
                                      _trans.most_popular,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                );
                        case 'popular':
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridWidget(
                              restaurantsList: homeModel.popularRestaurants,
                              heroTag: 'home_restaurants',
                            ),
                          );
                        case 'recent_reviews_heading':
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListTile(
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 20),
                              leading: Icon(
                                Icons.recent_actors,
                                color: Theme.of(context).hintColor,
                              ),
                              title: Text(
                                _trans.recent_reviews,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          );
                        case 'recent_reviews':
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ReviewsListWidget(
                                reviewsList: homeModel.recentReviews),
                          );
                        default:
                          return const SizedBox(height: 0);
                      }
                    }),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
