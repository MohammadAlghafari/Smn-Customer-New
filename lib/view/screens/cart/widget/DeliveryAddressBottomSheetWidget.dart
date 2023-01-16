import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/utili/app_config.dart' as config;
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

import 'DeliveryAddressDialog.dart';


class DeliveryAddressBottomSheetWidget extends StatefulWidget {
  const DeliveryAddressBottomSheetWidget({Key? key}) : super(key: key);

  @override
  _DeliveryAddressBottomSheetWidgetState createState() =>
      _DeliveryAddressBottomSheetWidgetState();
}

class _DeliveryAddressBottomSheetWidgetState
    extends State<DeliveryAddressBottomSheetWidget> {
  late AppLocalizations _trans;
  LocationResult? result;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, -30)),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Consumer<AuthViewModel>(
              builder: (context, authModel, child) {
                return ListView(
                  padding:
                      const EdgeInsets.only(top: 20, bottom: 15, left: 20, right: 20),
                  children: <Widget>[
                    Consumer<SettingViewModel>(
                      builder: (context, settingModel, child) {
                        return InkWell(
                          onTap: () async {

                            // LocationResult? result = await showLocationPicker(
                            //   context,
                            //   settingModel.setting.googleMapsKey,
                            //   initialCenter: LatLng(
                            //       authModel.deliveryAddress?.latitude ?? 0,
                            //       authModel.deliveryAddress?.longitude ?? 0),
                            //   //automaticallyAnimateToCurrentLocation: true,
                            //   //mapStylePath: 'assets/mapStyle.json',
                            //   myLocationButtonEnabled: true,
                            //   //resultCardAlignment: Alignment.bottomCenter,
                            // );
                            await showPlacePicker();

                            if (result != null) {
                              DeliveryAddressDialog(
                                context: context,
                                address: Address.fromJSON({
                                  'address': result!.formattedAddress!,
                                  'latitude': result != null
                                      ? result!.latLng!.latitude
                                      : '',
                                  'longitude': result != null
                                      ? result!.latLng!.longitude
                                      : '',
                                }),
                                onChanged: (Address _address) {
                                  authModel.addAddress(_address,context);
                                },
                              );
                            }
                            print("result = $result");
                            // Navigator.of(widget.scaffoldKey.currentContext).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(const Radius.circular(5)),
                                    color: Theme.of(context).focusColor),
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Theme.of(context).primaryColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _trans.add_new_delivery_address,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Theme.of(context).focusColor,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    Consumer<SettingViewModel>(
                      builder: (context, settingModel, child) {
                        return InkWell(
                          onTap: () {

                            authModel
                                .changeDeliveryAddressToCurrentLocation(
                                    settingModel.setting.googleMapsKey,context)
                                .then((value) {
                              // Navigator.of(widget.scaffoldKey.currentContext).pop();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(5)),
                                    color: Theme.of(context).accentColor),
                                child: Icon(
                                  Icons.my_location,
                                  color: Theme.of(context).primaryColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _trans.current_location,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Theme.of(context).focusColor,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: authModel.addresses.length,
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 25);
                      },
                      itemBuilder: (context, index) {
//                return DeliveryAddressesItemWidget(
//                  address: _con.addresses.elementAt(index),
//                  onPressed: (Address _address) {
//                    _con.chooseDeliveryAddress(_address);
//                  },
//                  onLongPress: (Address _address) {
//                    DeliveryAddressDialog(
//                      context: context,
//                      address: _address,
//                      onChanged: (Address _address) {
//                        _con.updateAddress(_address);
//                      },
//                    );
//                  },
//                  onDismissed: (Address _address) {
//                    _con.removeDeliveryAddress(_address);
//                  },
//                );

                        return InkWell(
                          onLongPress: () {
                            DeliveryAddressDialog(
                              context: context,
                              address: authModel.addresses.elementAt(index),
                              onChanged: (Address _address) {
                                authModel.updateAddress(_address);
                              },
                            );
                          },
                          onTap: () {
                            authModel
                                .changeDeliveryAddress(
                                    authModel.addresses.elementAt(index),context)
                                .then((value) {
                              Navigator.of(context)
                                  .pop();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        const BorderRadius.all(const Radius.circular(5)),
                                    color: Theme.of(context).focusColor),
                                child: Icon(
                                  Icons.place,
                                  color: Theme.of(context).primaryColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            authModel.addresses
                                                        .elementAt(index)
                                                        .description.isNotEmpty
                                                ? authModel.addresses
                                                    .elementAt(index)
                                                    .description
                                                : authModel.addresses
                                                            .elementAt(index)
                                                            .address !=
                                                        null
                                                    ? authModel.addresses
                                                        .elementAt(index)
                                                        .address!
                                                    : _trans.unknown,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Theme.of(context).focusColor,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: 13, horizontal: config.App().appWidth(42)),
            decoration: BoxDecoration(
              color: Theme.of(context).focusColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            ),
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                color: Theme.of(context).focusColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
              ),
              //child: SizedBox(height: 1,),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showPlacePicker() async {
    result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => PlacePicker(
            "AIzaSyD_lRvTskGkN80rrp59iaaMPyG8SmzZRQE",
          )),
    );

  }

}
