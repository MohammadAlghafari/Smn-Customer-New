import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/screens/address/widget/DeliveryAddressesItemWidget.dart';
import 'package:smn_delivery_app/view/screens/address/widget/EmptyAddressesWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/DeliveryAddressDialog.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class DeliveryAddressesScreen extends StatefulWidget {
  DeliveryAddressesScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DeliveryAddressesScreenState createState() =>
      _DeliveryAddressesScreenState();
}

class _DeliveryAddressesScreenState extends State<DeliveryAddressesScreen> {
  late AppLocalizations _trans;
  LocationResult? result;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.delivery_addresses,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showPlacePicker();

            if (result != null) {
              DeliveryAddressDialog(
                context: context,
                address: Address.fromJSON({
                  'address': result!.formattedAddress!,
                  'latitude': result != null ? result!.latLng!.latitude : '',
                  'longitude': result != null ? result!.latLng!.longitude : '',
                }),
                onChanged: (Address _address) {
                  Provider.of<AuthViewModel>(context, listen: false)
                      .addAddress(_address, context);
                },
              );
            }

            print("result = $result");
            //setState(() => _pickedLocation = result);
          },
          backgroundColor: Theme.of(context).accentColor,
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          )),
      body: Consumer<AuthViewModel>(
        builder: (context, authModel, child) {
          return RefreshIndicator(
            onRefresh: authModel.refreshAddresses,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 20),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.map,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        _trans.delivery_addresses,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      subtitle: Text(
                        _trans.long_press_to_edit_item_swipe_item_to_delete_it,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  authModel.addresses.isEmpty
                      ? EmptyAddressesWidget()
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: authModel.addresses.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 15);
                          },
                          itemBuilder: (context, index) {
                            return DeliveryAddressesItemWidget(
                              address: authModel.addresses.elementAt(index),
                              onPressed: (Address _address) {
                                DeliveryAddressDialog(
                                  context: context,
                                  address: _address,
                                  onChanged: (Address _address) {
                                    authModel.updateAddress(_address);
                                  },
                                );
                              },
                              onLongPress: (Address _address) {
                                DeliveryAddressDialog(
                                  context: context,
                                  address: _address,
                                  onChanged: (Address _address) {
                                    authModel.updateAddress(_address);
                                  },
                                );
                              },
                              onDismissed: (Address _address) {
                                authModel.removeDeliveryAddress(_address);
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        },
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
