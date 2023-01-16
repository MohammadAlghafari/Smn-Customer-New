import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/EmptyCartWidget.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodItemWidget.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodsCarouselItemWidget.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodsCarouselLoaderWidget.dart';
import 'package:smn_delivery_app/view/screens/food/widget/FoodsCarouselWidget.dart';
import 'package:smn_delivery_app/view/customWidget/search/SearchBarWidget.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view/screens/messages/widget/EmptyMessagesWidget.dart';
import 'package:smn_delivery_app/view_models/restaurants_view_model.dart';

class RestaurantMenuNavBarScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantMenuNavBarScreen({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RestaurantMenuNavBarScreenState createState() =>
      _RestaurantMenuNavBarScreenState();
}

class _RestaurantMenuNavBarScreenState
    extends State<RestaurantMenuNavBarScreen> {
  List<String> selectedCategories = [];
  late AppLocalizations _trans;

  @override
  void initState() {
    Provider.of<RestaurantsViewModel>(context, listen: false)
        .listenForTrendingFoods(widget.restaurantId);
    selectedCategories = ['0'];
    Provider.of<RestaurantsViewModel>(context, listen: false)
        .listenForFoods(widget.restaurantId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Consumer<RestaurantsViewModel>(
          builder: (context, restaurantModel, child) {
            return Text(
              restaurantModel.restaurant?.name ?? '',
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(const TextStyle(letterSpacing: 0)),
            );
          },
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(
                onClickFilter: (value) {},
              ),
            ),
            Consumer<RestaurantsViewModel>(
              builder: (context, restaurantModel, child) {
                return Column(
                  children: [
                    restaurantModel.featuredFoods.isEmpty
                        ? Container()
                        : ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            leading: Icon(
                              Icons.bookmark,
                              color: Theme.of(context).hintColor,
                            ),
                            title: Text(
                              _trans.featured_foods,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            subtitle: Text(
                              _trans.clickOnTheFoodToGetMoreDetailsAboutIt,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                    restaurantModel.loadingFeaturedFoods
                        ? const FoodsCarouselLoaderWidget()
                        : Container(
                        height: restaurantModel.featuredFoods.isEmpty ?0:210,
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                          itemCount: restaurantModel.featuredFoods.length,
                          itemBuilder: (context, index) {
                            double _marginLeft = 0;
                            (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                            return FoodsCarouselItemWidget(
                              heroTag: 'image_featured_food',
                              marginLeft: _marginLeft,
                              food: restaurantModel.featuredFoods.elementAt(index),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        )),
                    ListTile(
                      dense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Icon(
                        Icons.subject,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        _trans.all_menu,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                        _trans.clickOnTheFoodToGetMoreDetailsAboutIt,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),

                    restaurantModel.categories.length==1
                        ? const SizedBox(height: 0)
                        : SizedBox(
                      height: 90,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView(
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: List.generate(restaurantModel.categories.length, (index) {
                                var _category = restaurantModel.categories.elementAt(index);
                                var _selected = selectedCategories.contains(_category.id);
                                return Padding(
                                  padding: const EdgeInsetsDirectional.only(start: 20),
                                  child: RawChip(
                                    elevation: 0,
                                    pressElevation: 0,
                                    label: Text(_category.name),
                                    labelStyle: _selected
                                        ? Theme.of(context).textTheme.bodyText2!.merge(TextStyle(color: Theme.of(context).primaryColor))
                                        : Theme.of(context).textTheme.bodyText2,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                    backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                                    selectedColor: Theme.of(context).accentColor,
                                    selected: _selected,
                                    //shape: StadiumBorder(side: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.05))),
                                    showCheckmark: false,
                                    avatar: (_category.id == '0')
                                        ? null
                                        : (_category.image.url!.toLowerCase().endsWith('.svg')
                                        ? SvgPicture.network(
                                      _category.image.url!,
                                      color: _selected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,
                                    )
                                        : CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: _category.image.icon!,
                                      color: _selected ? Theme.of(context).primaryColor : Theme.of(context).accentColor,

                                      placeholder: (context, url) => Image.asset(
                                        'assets/img/loading.gif',
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    )),
                                    onSelected: (bool value) {
                                      setState(() {
                                        if (_category.id == '0') {
                                          selectedCategories = ['0'];
                                        } else {
                                          selectedCategories.removeWhere((element) => element == '0');
                                        }
                                        if (value) {
                                          selectedCategories.add(_category.id);
                                        } else {
                                          selectedCategories.removeWhere((element) => element == _category.id);
                                        }
                                        restaurantModel.selectCategory(selectedCategories);
                                      });
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    restaurantModel.foods.isEmpty
                        ? CircularLoadingWidget(height: 250)
                        : ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: restaurantModel.foods.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              return FoodItemWidget(
                                heroTag: 'menu_list',
                                food: restaurantModel.foods.elementAt(index),
                              );
                            },
                          ),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
