import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view/screens/messages/widget/EmptyMessagesWidget.dart';
import 'package:smn_delivery_app/view_models/search_view_model.dart';

import '../../screens/restaurant/widget/CardWidget.dart';
import '../Circular_loading_widget.dart';
import '../../screens/food/widget/FoodItemWidget.dart';
import 'EmptySearchWidget.dart';

class SearchResultWidget extends StatefulWidget {
  final String heroTag;

  SearchResultWidget({Key? key, required this.heroTag}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              trailing: IconButton(
                icon: Icon(Icons.close),
                color: Theme.of(context).hintColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                _trans.search,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                _trans.ordered_by_nearby_first,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onSubmitted: (text) async {
                await Provider.of<SearchViewModel>(context, listen: false)
                    .refreshSearch(text);
                Provider.of<SearchViewModel>(context, listen: false)
                    .saveSearch(text);
              },
              autofocus: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: _trans.search_for_restaurants_or_foods,
                hintStyle: Theme.of(context)
                    .textTheme
                    .caption!
                    .merge(TextStyle(fontSize: 14)),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.3))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).focusColor.withOpacity(0.1))),
              ),
            ),
          ),
          Consumer<SearchViewModel>(
            builder: (context, searchModel, child) {
              if (searchModel.loadingFoods || searchModel.loadingRestaurants) {
                return CircularLoadingWidget(height: 10);
              }

              return searchModel.restaurants.isEmpty &&
                      searchModel.foods.isEmpty
                  ? EmptySearchWidget()
                  : Expanded(
                      child: ListView(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              title: Text(
                                _trans.foods_results,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),
                          ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: searchModel.foods.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              return FoodItemWidget(
                                heroTag: 'search_list',
                                food: searchModel.foods.elementAt(index),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                              title: Text(
                                _trans.restaurants_results,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: searchModel.restaurants.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      'RestaurantDetailsScreen',
                                      arguments: searchModel.restaurants
                                          .elementAt(index)
                                          .id);
                                },
                                child: CardWidget(
                                    restaurant: searchModel.restaurants
                                        .elementAt(index),
                                    heroTag: widget.heroTag),
                              );
                            },
                          ),
                        ],
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}
