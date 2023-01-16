import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/const/url.dart' as url;
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/cart/model/cart_item.dart';
import 'package:smn_delivery_app/data/home/model/food_order.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/data/setting/model/setting.dart';
import 'package:smn_delivery_app/smn_customer.dart';
import 'package:smn_delivery_app/utili/app_config.dart' as config;
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class Helper {
  DateTime? currentBackPressTime;

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader.remove();
      } catch (e) {}
    });
  }

  OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: CircularLoadingWidget(height: 200),
        ),
      );
    });
    return loader;
  }

  static Widget getPrice(double myPrice, BuildContext context,
      {TextStyle? style, String zeroPlaceholder = '-'}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize! + 2));
    }
    try {
      if (myPrice == 0) {
        return Text(zeroPlaceholder, style: style ?? Theme.of(context).textTheme.subtitle1);
      }
      return Consumer<SettingViewModel>(builder: (context, settingModel, child) {
        return RichText(
          softWrap: false,
          overflow: TextOverflow.fade,
          maxLines: 1,
          text: settingModel.setting.currencyRight != null && settingModel.setting.currencyRight == false
              ? TextSpan(
            text: settingModel.setting.defaultCurrency,
            style: style == null
                ? Theme.of(context).textTheme.subtitle1!.merge(
              TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .fontSize! -
                      6),
            )
                : style.merge(TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: style.fontSize! - 6)),
            children: <TextSpan>[
              TextSpan(
                  text: myPrice
                      .toStringAsFixed(settingModel.setting.currencyDecimalDigits),
                  style: style ?? Theme.of(context).textTheme.subtitle1),
            ],
          )
              : TextSpan(
            text: myPrice.toStringAsFixed(settingModel.setting.currencyDecimalDigits),
            style: style ?? Theme.of(context).textTheme.subtitle1,
            children: <TextSpan>[
              TextSpan(
                text: settingModel.setting.defaultCurrency,
                style: style == null
                    ? Theme.of(context).textTheme.subtitle1!.merge(
                  TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .fontSize! -
                          6),
                )
                    : style.merge(TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: style.fontSize! - 6)),
              ),
            ],
          ),
        );
      },);
    } catch (e) {
      return Text('');
    }
  }

  static double getTotalOrdersPrice(Order order) {
    double total = 0;

    if (order != null && order.foodOrders != null) {
      order.foodOrders.forEach((foodOrder) {
        total += getTotalOrderPrice(foodOrder);
      });
      total += order.deliveryFee;
      total += order.tax * total / 100;
    }
    return total;
  }

  static double getTotalOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    total *= foodOrder.quantity;
    return total;
  }

  static double getTaxOrder(Order order) {
    double total = 0;
    if (order != null && order.foodOrders != null) {
      order.foodOrders.forEach((foodOrder) {
        total += getTotalOrderPrice(foodOrder);
      });
      return order.tax * total / 100;
    } else
      return total;
  }

  static double getOrderPrice(FoodOrder foodOrder) {
    double total = foodOrder.price;
    foodOrder.extras.forEach((extra) {
      total += extra.price != null ? extra.price : 0;
    });
    return total;
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(url.baseUrl).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(url.baseUrl).scheme,
        host: Uri.parse(url.baseUrl).host,
        port: Uri.parse(url.baseUrl).port,
        path: _path + path);
    return uri;
  }


  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body!.text).documentElement!.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static Html applyHtml(context, String html, {TextStyle? style}) {
    return Html(
      data: html,
      style: {
        "*": Style(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          color: Theme.of(context).hintColor,
          fontSize: FontSize(16.0),
          display: Display.INLINE_BLOCK,
          width: config.App().appWidth(100),
        ),
        "h4,h5,h6": Style(
          fontSize: FontSize(18.0),
        ),
        "h1,h2,h3": Style(
          fontSize: FontSize.xLarge,
        ),
        "br": Style(
          height: 0,
        ),
        "p": Style(
          fontSize: FontSize(16.0),
        )
      },
    );
  }



  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static Future<Marker> getMyPositionMarker(
      double latitude, double longitude) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  static AlignmentDirectional getAlignmentDirectional(
      String alignmentDirectional) {
    switch (alignmentDirectional) {
      case 'top_start':
        return AlignmentDirectional.topStart;
      case 'top_center':
        return AlignmentDirectional.topCenter;
      case 'top_end':
        return AlignmentDirectional.topEnd;
      case 'center_start':
        return AlignmentDirectional.centerStart;
      case 'center':
        return AlignmentDirectional.topCenter;
      case 'center_end':
        return AlignmentDirectional.centerEnd;
      case 'bottom_start':
        return AlignmentDirectional.bottomStart;
      case 'bottom_center':
        return AlignmentDirectional.bottomCenter;
      case 'bottom_end':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.bottomEnd;
    }
  }

  static BoxFit getBoxFit(String boxFit) {
    switch (boxFit) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fit_height':
        return BoxFit.fitHeight;
      case 'fit_width':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      case 'scale_down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  Color getColorFromHex(String hex) {
    if (hex.contains('#')) {
      return Color(int.parse(hex.replaceAll("#", "0xFF")));
    } else {
      return Color(int.parse("0xFF" + hex));
    }
  }

  static String getDistance(double distance, String unit, String distanceUnit) {
    String _unit = distanceUnit;
    if (_unit == 'km') {
      distance *= 1.60934;
    }
    return distance != null ? distance.toStringAsFixed(2) + " " + unit : "";
  }

  String trans(String text) {
    switch (text) {
      case "App\\Notifications\\OrderCanceled":
        return AppLocalizations.of(
                NavigationService.navigatorKey.currentContext!)!
            .order_status_changed;
      case "App\\Notifications\\StatusChangedOrder":
        return AppLocalizations.of(
                NavigationService.navigatorKey.currentContext!)!
            .order_status_changed;
      case "App\\Notifications\\NewOrder":
        return AppLocalizations.of(
                NavigationService.navigatorKey.currentContext!)!
            .new_order_from_client;
      case "km":
        return AppLocalizations.of(
                NavigationService.navigatorKey.currentContext!)!
            .km;
      case "mi":
        return AppLocalizations.of(
                NavigationService.navigatorKey.currentContext!)!
            .mi;
      default:
        return "";
    }
  }

  static bool canDelivery(
      Restaurant _restaurant, Address? deliveryAddress, Setting setting,
      {List<CartItem>? carts}) {
    bool _can = true;
    String _unit = setting.distanceUnit;
    double _deliveryRange = _restaurant.deliveryRange;
    double _distance = _restaurant.distance;
    carts?.forEach((CartItem _cart) {
      _can &= _cart.food.deliverable;
    });

    if (_unit == 'km') {
      _deliveryRange /= 1.60934;
    }
    if (_distance == 0 &&
        deliveryAddress != null &&
        !deliveryAddress.isUnknown()) {
      _distance = sqrt(pow(
              69.1 *
                  (double.parse(_restaurant.latitude) -
                      deliveryAddress.latitude),
              2) +
          pow(
              69.1 *
                  (deliveryAddress.longitude -
                      double.parse(_restaurant.longitude)) *
                  cos(double.parse(_restaurant.latitude) / 57.3),
              2));
    }
    _can &= _restaurant.availableForDelivery &&
        deliveryAddress != null &&
        deliveryAddress != null &&
        (_distance < _deliveryRange) &&
        !deliveryAddress.isUnknown();
    return _can;
  }

  static Future<Marker> getMarker(
      Map<String, dynamic> res, Setting setting) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/marker.png', 90);
    final Marker marker = Marker(
        markerId: MarkerId(res['id']),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
        anchor: const Offset(0.5, 0.5),

        infoWindow: InfoWindow(
            title: res['name'],
            snippet: getDistance(res['distance'].toDouble(),
                Helper().trans(setting.distanceUnit), setting.distanceUnit),
            onTap: () {
              // print(CustomTrace(StackTrace.current, messages: 'Info Window'));
            }),
        position: LatLng(
            double.parse(res['latitude']), double.parse(res['longitude'])));

    return marker;
  }
}
