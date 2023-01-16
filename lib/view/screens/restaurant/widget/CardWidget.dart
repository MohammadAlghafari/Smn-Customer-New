import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/utili/maps_util.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

// ignore: must_be_immutable
class CardWidget extends StatelessWidget {
  Restaurant restaurant;
  String heroTag;
  late AppLocalizations _trans;

  CardWidget({Key? key, required this.restaurant, required this.heroTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Container(
      width: 300,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5)),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image of the card
            Stack(
              fit: StackFit.loose,
              alignment: AlignmentDirectional.bottomStart,
              children: <Widget>[
                Hero(
                  tag: heroTag + restaurant.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: restaurant.image.url!,
                      placeholder: (context, url) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 150,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                      decoration: BoxDecoration(
                          color: restaurant.closed ? Colors.grey : Colors.green,
                          borderRadius: BorderRadius.circular(24)),
                      child: restaurant.closed
                          ? Text(
                              _trans.closed,
                              style: Theme.of(context).textTheme.caption!.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            )
                          : Text(
                              _trans.open,
                              style: Theme.of(context).textTheme.caption!.merge(
                                  TextStyle(
                                      color: Theme.of(context).primaryColor)),
                            ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    //   decoration: BoxDecoration(
                    //       color: deliveryAddress.value?.address != null
                    //           ? Colors.green
                    //           : Colors.orange,
                    //       borderRadius: BorderRadius.circular(24)),
                    //   child: deliveryAddress.value?.address != null
                    //       ? Text(
                    //           _trans.delivery,
                    //           style: Theme.of(context).textTheme.caption!.merge(
                    //               TextStyle(
                    //                   color: Theme.of(context).primaryColor)),
                    //         )
                    //       : Text(
                    //           _trans.pickup,
                    //           style: Theme.of(context).textTheme.caption!.merge(
                    //               TextStyle(
                    //                   color: Theme.of(context).primaryColor)),
                    //         ),
                    // ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          restaurant.name,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          Helper.skipHtml(restaurant.description),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: Helper.getStarsList(
                              double.parse(restaurant.rate)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                         /* Container(
                            width: 55,
                            height: 40,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                MapsUtil.openMap(restaurant.latitude,
                                    restaurant.longitude);
                              },
                              child: Icon(Icons.directions,
                                  color: Theme.of(context).primaryColor),
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                          SizedBox(width: 10),*/
                          Container(
                            width: 55,
                            height: 40,
                            child: FlatButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'HomeScreen', (route) => false,
                                    arguments: {
                                      'initialPage': 1,
                                      'restaurantAddress': Address.fromJSON({
                                        'latitude': double.parse(restaurant.latitude),
                                        'longitude': double.parse(restaurant.longitude)
                                      })
                                    });
                              },
                              child: Icon(Icons.location_on_outlined,
                                  color: Theme.of(context).primaryColor),
                              color: Theme.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      restaurant.distance > 0
                          ? Consumer<SettingViewModel>(
                              builder: (context, settingModel, child) {
                                return Text(
                                  Helper.getDistance(
                                      restaurant.distance,
                                      Helper().trans(
                                          settingModel.setting.distanceUnit),
                                      settingModel.setting.distanceUnit),
                                  overflow: TextOverflow.fade,
                                  maxLines: 1,
                                  softWrap: false,
                                );
                              },
                            )
                          : const SizedBox(height: 0)
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
