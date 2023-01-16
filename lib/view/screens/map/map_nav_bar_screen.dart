import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/view/screens/restaurant/widget/CardsCarouselWidget.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view_models/restaurants_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapNavBarScreen extends StatefulWidget {
  Address? restaurantAddress;
   MapNavBarScreen({Key? key,this.restaurantAddress}) : super(key: key);

  @override
  _MapNavBarScreenState createState() => _MapNavBarScreenState();
}

class _MapNavBarScreenState extends State<MapNavBarScreen> {

  late AppLocalizations _trans;

  @override
  void initState() {

      Provider.of<RestaurantsViewModel>(context, listen: false)
          .getCurrentLocation(widget.restaurantAddress);
      // Provider.of<RestaurantsViewModel>(context, listen: false)
      //     .goCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // leading: _con.currentRestaurant?.latitude == null
        //     ?  IconButton(
        //   icon:  Icon(Icons.sort, color: Theme.of(context).hintColor),
        //   onPressed: () =>
        //       widget.parentScaffoldKey.currentState.openDrawer(),
        // )
        //     : IconButton(
        //   icon:  Icon(Icons.arrow_back,
        //       color: Theme.of(context).hintColor),
        //   onPressed: () =>
        //       Navigator.of(context).pushNamed('/Pages', arguments: 2),
        // ),
        title: Text(
          _trans.maps_explorer,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Consumer<RestaurantsViewModel>(
        builder: (context, restaurantModel, child) {
          return Stack(
//        fit: StackFit.expand,
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              restaurantModel.cameraPosition == null
                  ? Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: CircularLoadingWidget(height: 500),
              )
                  : GoogleMap(
                //zoomControlsEnabled: true,
                mapToolbarEnabled: false,
                minMaxZoomPreference: const MinMaxZoomPreference(9,13),
                mapType: MapType.normal,
                initialCameraPosition: restaurantModel.cameraPosition!,
                markers: Set.from(restaurantModel.allMarkers),
                onMapCreated: (GoogleMapController controller) {
                  if (!restaurantModel.mapController.isCompleted) {
                    restaurantModel.mapController.complete(controller);
                  }
                  if (restaurantModel.cameraPosition != null) {
                    controller.moveCamera(CameraUpdate.newCameraPosition(
                        restaurantModel.cameraPosition!));
                  }
                },
                onCameraMove: (CameraPosition cameraPosition) {
                  restaurantModel.cameraPosition = cameraPosition;
                },
                onCameraIdle: () {
                  restaurantModel.getRestaurantsOfArea();
                },
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                //polylines: _con.polylines,
              ),
              CardsCarouselWidget(
                restaurantsList: restaurantModel.topRestaurants,
                heroTag: 'map_restaurants',
              ),
            ],
          );
        },
      ),
    );
  }

}
