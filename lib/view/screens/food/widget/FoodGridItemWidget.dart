import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/utili/helper.dart';

class FoodGridItemWidget extends StatefulWidget {
  final String heroTag;
  final Food food;
  final VoidCallback onPressed;

  FoodGridItemWidget(
      {Key? key,
      required this.heroTag,
      required this.food,
      required this.onPressed})
      : super(key: key);

  @override
  _FoodGridItemWidgetState createState() => _FoodGridItemWidgetState();
}

class _FoodGridItemWidgetState extends State<FoodGridItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Theme.of(context).accentColor.withOpacity(0.08),
      onTap: () {
        // Navigator.of(context).pushNamed('/Food', arguments: new RouteArgument(heroTag: this.widget.heroTag, id: this.widget.food.id));
        Navigator.of(context)
            .pushNamed('FoodDetailsScreen', arguments: widget.food);
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Expanded(
              //   child: Hero(
              //     tag: widget.heroTag + widget.food.id,
              //     child: Container(
              //       decoration: BoxDecoration(
              //         image: DecorationImage(
              //             image: NetworkImage(widget.food.image.thumb!),
              //             fit: BoxFit.cover),
              //         borderRadius: BorderRadius.circular(5),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: Hero(
                  tag: widget.heroTag + widget.food.id,
                  child: CachedNetworkImage(
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: widget.food.image.thumb!,
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

              const SizedBox(height: 5),
              Text(
                widget.food.name,
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                widget.food.restaurant.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: 40,
            height: 40,
            child: FlatButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                widget.onPressed();
              },
              child: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              color: Theme.of(context).accentColor.withOpacity(0.9),
              shape: const StadiumBorder(),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 40,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(3),
              color: Theme.of(context).colorScheme.secondary,
              child: Helper.getPrice(
                  widget.food.discountPrice != 0
                      ? widget.food.discountPrice
                      : widget.food.price,
                  context,
                  style: const TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
