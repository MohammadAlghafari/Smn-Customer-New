import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/home/model/food_order.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class FoodOrderItemWidget extends StatelessWidget {
  final String heroTag;
  final FoodOrder foodOrder;
  final Order order;
  bool? taped;
   FoodOrderItemWidget(
      { Key ?key,
      required this.foodOrder,
       this.taped,
      required this.order,
      required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: taped??true?() {

        Navigator.of(context).pushNamed('TrackingWidget', arguments: order);

        // Navigator.of(context).pushNamed('/Food', arguments: RouteArgument(id: this.foodOrder.food.id));
      }:null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: heroTag + foodOrder.id,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  imageUrl: foodOrder.food.image.thumb!,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          foodOrder.food.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Wrap(
                          children:
                              List.generate(foodOrder.extras.length, (index) {
                            return Text(
                              foodOrder.extras.elementAt(index).name + ', ',
                              style: Theme.of(context).textTheme.caption,
                            );
                          }),
                        ),
                        Text(
                          foodOrder.food.restaurant.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[

                      Helper.getPrice(Helper.getOrderPrice(foodOrder), context,
                          style: Theme.of(context).textTheme.subtitle1),
                      Text(
                        " x " + foodOrder.quantity.toInt().toString(),
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
