import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/cart/model/cart_item.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/view/customWidget/swipe_widget.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  String heroTag;
  CartItem cart;
  VoidCallback increment;
  VoidCallback decrement;
  VoidCallback onDismissed;

  CartItemWidget(
      {Key? key,
      required this.cart,
      required this.heroTag,
      required this.increment,
      required this.decrement,
      required this.onDismissed})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return OnSlide(
      // background: Container(color: Theme.of(context).colorScheme.secondary),
      // key: Key(widget.cart.food.id),
      // onDismissed: (direction) {
      //   setState(() {
      //     widget.onDismissed();
      //   });
      // },
      items: <ActionItems>[
        ActionItems(
            icon: Icon(Icons.delete, color: Theme.of(context).accentColor),
            onPress: () {
              widget.onDismissed();
            },
            backgroudColor: Theme.of(context).scaffoldBackgroundColor),
      ],
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        focusColor: Theme.of(context).accentColor,
        highlightColor: Theme.of(context).primaryColor,
        onTap: () {
          // Navigator.of(context).pushNamed('/Food', arguments: RouteArgument(id: widget.cart.food.id, heroTag: widget.heroTag));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).focusColor.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.all(const Radius.circular(5)),
                child: CachedNetworkImage(
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  imageUrl: widget.cart.food.image.thumb!,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    height: 90,
                    width: 90,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 15),
              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.cart.food.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Wrap(
                            children: List.generate(widget.cart.extras.length,
                                (index) {
                              return Text(
                                widget.cart.extras.elementAt(index).name + ', ',
                                style: Theme.of(context).textTheme.caption,
                              );
                            }),
                          ),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: <Widget>[
                              widget.cart.food.discountPrice > 0
                                  ? Helper.getPrice(
                                  widget.cart.food.discountPrice*widget.cart.quantity, context,
                                  style:Theme.of(context).textTheme.headline4 )
                                  : const SizedBox(height: 0),
                              Helper.getPrice(widget.cart.food.price*widget.cart.quantity, context,
                                  style:widget.cart.food.discountPrice > 0? Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText2!
                                  .merge(const TextStyle(
                                  decoration: TextDecoration
                                      .lineThrough)):Theme.of(context).textTheme.headline4),

                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.decrement();
                            });
                          },
                          iconSize: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                        SizedBox(
                          width: 18,
                          child: Center(
                            child: Text(widget.cart.quantity.toInt().toString(),
                                style: Theme.of(context).textTheme.subtitle1),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.increment();
                            });
                          },
                          iconSize: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          icon: const Icon(Icons.add_circle_outline),
                          color: Theme.of(context).hintColor,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
