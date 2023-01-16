import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/screens/restaurant/restaurant_map_nav_bar_screen.dart';
import 'package:smn_delivery_app/view/screens/restaurant/restaurant_details_nav_bar_screen.dart';
import 'package:smn_delivery_app/view/screens/restaurant/restaurant_menu_nav_bar_screen.dart';
import 'package:smn_delivery_app/view_models/restaurants_view_model.dart';

import 'restaurant_chat_nav_bar_screen.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final String restaurantId;

  RestaurantDetailsScreen({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RestaurantDetailsScreenState createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late AppLocalizations _trans;
  late PageController _pageController;
  late int _selectedIndex;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _selectedIndex = 0;
    Provider.of<RestaurantsViewModel>(context, listen: false)
        .init(widget.restaurantId.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return Consumer<RestaurantsViewModel>(
      builder: (context, restaurantModel, child) {
        if (restaurantModel.isLoadingRestaurant()) {
          return Scaffold(
              body: Center(child: CircularLoadingWidget(height: 200)));
        }
        return Scaffold(
          body: PageView(
            children: [
              RestaurantDetailsNavBarScreen(
                restaurantId: widget.restaurantId,
              ),
              RestaurantChatNavBarScreen(
                restaurantId: widget.restaurantId,
              ),
              RestaurantMapNavBarScreen(
                restaurantId: widget.restaurantId,
              ),
              RestaurantMenuNavBarScreen(
                restaurantId: widget.restaurantId,
              ),
            ],
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (p) {
              setState(() {
                _selectedIndex = p;
              });
            },
            controller: _pageController,
          ),
          bottomNavigationBar: Container(
            height: 66,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.10),
                    offset: const Offset(0, -4),
                    blurRadius: 10)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: SizedBox()),
                IconButton(
                  tooltip: _trans.home,
                  icon: Icon(
                    Icons.store,
                    size: _selectedIndex == 0 ? 28 : 24,
                    color: _selectedIndex == 0
                        ? Theme.of(context).accentColor
                        : Theme.of(context).focusColor,
                  ),
                  onPressed: () {
                    _onTappedBar(0);
                  },
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  tooltip: _trans.messages,
                  icon: Icon(
                    Icons.chat,
                    size: _selectedIndex == 1 ? 28 : 24,
                    color: _selectedIndex == 1
                        ? Theme.of(context).accentColor
                        : Theme.of(context).focusColor,
                  ),
                  onPressed: () {
                    _onTappedBar(1);
                  },
                ),
                const Expanded(child: SizedBox()),

                IconButton(
                  tooltip: _trans.location,
                  icon: Icon(
                    Icons.directions,
                    size: _selectedIndex == 2 ? 28 : 24,
                    color: _selectedIndex == 2
                        ? Theme.of(context).accentColor
                        : Theme.of(context).focusColor,
                  ),
                  onPressed: () {
                    _onTappedBar(2);
                  },
                ),
                const Expanded(child: SizedBox()),

                Consumer<RestaurantsViewModel>(
                  builder: (context, restaurantModel, child) {

                    if ((restaurantModel.foods.isEmpty)) {
                      return Container();
                    }
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: Tooltip(
                        message: _trans.menu,
                        child: FlatButton(
                          onPressed: () {
                            _onTappedBar(3);
                          },
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                          shape: const StadiumBorder(),
                          color: Theme.of(context).accentColor,
                          child: Wrap(
                            spacing: 10,
                            children: [
                              Icon(Icons.restaurant,
                                  color: Theme.of(context).primaryColor),
                              Text(
                                _trans.menu,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
