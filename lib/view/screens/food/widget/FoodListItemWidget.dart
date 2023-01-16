import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

// ignore: must_be_immutable
class FoodListItemWidget extends StatelessWidget {
  String heroTag;
  Food food;

  FoodListItemWidget({Key? key, required this.heroTag, required this.food})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.of(context).pushNamed('FoodDetailsScreen', arguments: food);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 5,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Hero(
            //   tag: heroTag + food.id,
            //   child: Container(
            //     height: 60,
            //     width: 60,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.all(Radius.circular(5)),
            //       image: DecorationImage(
            //           image: NetworkImage(food.image.thumb!),
            //           fit: BoxFit.cover),
            //     ),
            //   ),
            // ),
            Hero(
              tag: heroTag + food.id,
              child: Container(
                height: 60,
                width: 60,
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: food.image.thumb!,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          food.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          food.restaurant.name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Helper.getPrice(
                      food.discountPrice != 0 ? food.discountPrice : food.price,
                      context,
                      style: Theme.of(context).textTheme.headline4)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
