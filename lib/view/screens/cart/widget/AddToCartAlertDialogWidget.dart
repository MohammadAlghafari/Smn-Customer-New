import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import '../../../../generated/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef FoodBoolFunc = void Function(Food food, {bool reset});

class AddToCartAlertDialogWidget extends StatelessWidget {
  final Food oldFood;
  final Food newFood;
  final FoodBoolFunc onPressed;
  late AppLocalizations _trans;

   AddToCartAlertDialogWidget({
    Key? key,
    required this.oldFood,
    required this.newFood,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      title:  Text(_trans.reset_cart),
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
            child: Text(
              _trans.you_must_add_foods_of_the_same_restaurants_choose_one,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          InkWell(
            splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              onPressed(newFood, reset: true);
              //Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'new_restaurant' + newFood.restaurant.id,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(image: NetworkImage(newFood.restaurant.image.thumb!), fit: BoxFit.cover),
                      ),
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
                                newFood.restaurant.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _trans.reset_your_cart_and_order_meals_form_this_restaurant,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            splashColor: Theme.of(context).accentColor,
            focusColor: Theme.of(context).accentColor,
            highlightColor: Theme.of(context).primaryColor,
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), blurRadius: 5, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'old_restaurant' + oldFood.restaurant.id,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(image: NetworkImage(oldFood.restaurant.image.thumb!), fit: BoxFit.cover),
                      ),
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
                                oldFood.restaurant.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _trans.keep_your_old_meals_of_this_restaurant,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child:  Text(_trans.reset),
          onPressed: () {
            onPressed(newFood, reset: true);
            //Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child:  Text(_trans.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
