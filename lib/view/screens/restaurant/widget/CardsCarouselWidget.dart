import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';

import 'CardWidget.dart';

// ignore: must_be_immutable
class CardsCarouselWidget extends StatefulWidget {
  List<Restaurant> restaurantsList;
  String heroTag;

  CardsCarouselWidget(
      {Key? key, required this.restaurantsList, required this.heroTag})
      : super(key: key);

  @override
  _CardsCarouselWidgetState createState() => _CardsCarouselWidgetState();
}

class _CardsCarouselWidgetState extends State<CardsCarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.restaurantsList.isEmpty
        ? Container()
        : SizedBox(
            height: 288,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.restaurantsList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    //TODO restaurant tap (show details)
                    Navigator.of(context).pushNamed('RestaurantDetailsScreen',
                        arguments: widget.restaurantsList.elementAt(index).id);
                  },
                  child: CardWidget(
                      restaurant: widget.restaurantsList.elementAt(index),
                      heroTag: widget.heroTag),
                );
              },
            ),
          );
  }
}
