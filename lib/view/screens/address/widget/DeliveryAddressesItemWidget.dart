import 'package:flutter/material.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// ignore: must_be_immutable
class DeliveryAddressesItemWidget extends StatelessWidget {
  String? heroTag;
  Address address;
  ValueChanged<Address> onPressed;
  ValueChanged<Address> onLongPress;
  ValueChanged<Address>? onDismissed;
  late AppLocalizations _trans;

  DeliveryAddressesItemWidget(
      {Key? key,
         this.heroTag,
        required this.address,
        required this.onPressed,
        required this.onLongPress,
         this.onDismissed,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onDismissed != null) {
      return Dismissible(
        key: Key(DateTime.now().toString()),
        onDismissed: (direction) {
          onDismissed!(address);
        },
        child: buildItem(context),
      );
    } else {
      return buildItem(context);
    }
  }

  InkWell buildItem(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        onPressed(address);
      },
      onLongPress: () {
        onLongPress(address);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
            // Stack(
            //   alignment: AlignmentDirectional.center,
            //   children: <Widget>[
            //     Container(
            //       height: 60,
            //       width: 60,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.all(Radius.circular(8)),
            //           color: (address?.isDefault ?? false) ||
            //               (paymentMethod?.selected ?? false)
            //               ? Theme.of(context).accentColor
            //               : Theme.of(context).focusColor),
            //       child: Icon(
            //         (paymentMethod?.selected ?? false)
            //             ? Icons.check
            //             : Icons.place,
            //         color: Theme.of(context).primaryColor,
            //         size: 38,
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        address.description.isNotEmpty
                            ? Text(
                          address.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                            : address.address != null
                            ? Text(
                          address.address!,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style:
                          Theme.of(context).textTheme.subtitle1,
                        )
                            : Text(
                          address.address ?? _trans.unknown,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: address.description.isEmpty
                              ? Theme.of(context).textTheme.caption
                              : Theme.of(context).textTheme.subtitle1,
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
    );
  }
}
