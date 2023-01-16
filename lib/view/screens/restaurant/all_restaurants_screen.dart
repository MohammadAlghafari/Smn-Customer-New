import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view/screens/restaurant/widget/GridItemWidget.dart';
import 'package:smn_delivery_app/view/customWidget/search/SearchBarWidget.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/customWidget/end_drawer.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/home_view_model.dart';

class AllRestaurantsScreen extends StatefulWidget {
  const AllRestaurantsScreen({Key? key}) : super(key: key);

  @override
  _AllRestaurantsScreenState createState() => _AllRestaurantsScreenState();
}

class _AllRestaurantsScreenState extends State<AllRestaurantsScreen> {
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const EndDrawer(),
      appBar: AppBar(
        title: Text(
          _trans.all_kitchens,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: _trans.back,
          icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, homeModel, child) {
          // return ListView.builder(
          //   itemCount: homeModel.allRestaurants.length + 1, // Add one more item for progress indicator
          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
          //   itemBuilder: (BuildContext context, int index) {
          //     if (index == homeModel.allRestaurants.length) {
          //       return _buildProgressIndicator(homeModel.isLoading);
          //     } else {
          //       return  CardWidget(restaurant: homeModel.allRestaurants[index], heroTag: 'all_restaurants'+index.toString());
          //     }
          //   },
          //   controller: homeModel.sc,
          // );
          return RefreshIndicator(
            onRefresh: homeModel.refreshAllRestaurant,
            child: SingleChildScrollView(
              controller: homeModel.sc,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SearchBarWidget(
                      onClickFilter: (event) {
                        scaffoldKey.currentState!.openEndDrawer();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StaggeredGridView.countBuilder(
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      itemCount: homeModel.allRestaurants.length,
                      itemBuilder: (BuildContext context, int index) {
                        // if (index == homeModel.allRestaurants.length) {
                        //   return ;
                        // }
                        return GridItemWidget(
                            restaurant:
                                homeModel.allRestaurants.elementAt(index),
                            heroTag: 'all_restaurants' + index.toString());
                      },
                      //                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(index % 2 == 0 ? 1 : 2),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(
                          MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 2
                              : 4),
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                    ),
                  ),
                  _buildProgressIndicator(homeModel.isLoading)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressIndicator(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 0.0,
          child: const CircularProgressIndicator(
            color: Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
