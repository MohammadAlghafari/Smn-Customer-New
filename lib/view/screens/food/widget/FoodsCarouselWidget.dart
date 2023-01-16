import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';

import 'FoodsCarouselItemWidget.dart';
import 'FoodsCarouselLoaderWidget.dart';

class FoodsCarouselWidget extends StatelessWidget {
  final List<Food> foodsList;
  final String heroTag;

  FoodsCarouselWidget(
      {Key? key, required this.foodsList, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return foodsList.isEmpty
        // ? const FoodsCarouselLoaderWidget()
        ? Container()
        : Container(
            height: 210,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              itemCount: foodsList.length,
              itemBuilder: (context, index) {
                double _marginLeft = 0;
                (index == 0) ? _marginLeft = 20 : _marginLeft = 0;
                return FoodsCarouselItemWidget(
                  heroTag: heroTag,
                  marginLeft: _marginLeft,
                  food: foodsList.elementAt(index),
                );
              },
              scrollDirection: Axis.horizontal,
            ));
  }
}
