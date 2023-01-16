import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/screens/favorites/widget/FavoriteGridItemWidget.dart';
import 'package:smn_delivery_app/view/screens/favorites/widget/FavoriteListItemWidget.dart';
import 'package:smn_delivery_app/view/customWidget/PermissionDeniedWidget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/favorite_view_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String layout = 'grid';
  late AppLocalizations _trans;

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: _trans.back,
          icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.favorites,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .merge(const TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(
              iconColor: Theme.of(context).hintColor,
              labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authModel, child) {
          if (authModel.user == null) {
            return PermissionDeniedWidget();
          }
          return RefreshIndicator(
            onRefresh: Provider.of<FavoriteViewModel>(context, listen: false)
                .refreshFavorites,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      leading: Icon(
                        Icons.favorite,
                        color: Theme.of(context).hintColor,
                      ),
                      title: Text(
                        _trans.favorite_foods,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              setState(() {
                               layout = 'list';
                              });
                            },
                            icon: Icon(
                              Icons.format_list_bulleted,
                              color: layout == 'list'
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).focusColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                layout = 'grid';
                              });
                            },
                            icon: Icon(
                              Icons.apps,
                              color: layout == 'grid'
                                  ? Theme.of(context).accentColor
                                  : Theme.of(context).focusColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Consumer<FavoriteViewModel>(
                    builder: (context, favoriteModel, child) {
                      return Column(
                        children: [
                          favoriteModel.favorites.isEmpty
                              ? CircularLoadingWidget(height: 500)
                              : Offstage(
                                  offstage: layout != 'list',
                                  child: ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: favoriteModel.favorites.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                    itemBuilder: (context, index) {
                                      return FavoriteListItemWidget(
                                        heroTag: 'favorites_list',
                                        favorite: favoriteModel.favorites
                                            .elementAt(index),
                                      );
                                    },
                                  ),
                                ),
                          favoriteModel.favorites.isEmpty
                              ?Container()
                              : Offstage(
                                  offstage: layout != 'grid',
                                  child: GridView.count(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 20,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 20),
                                    // Create a grid with 2 columns. If you change the scrollDirection to
                                    // horizontal, this produces 2 rows.
                                    crossAxisCount:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? 2
                                            : 4,
                                    // Generate 100 widgets that display their index in the List.
                                    children: List.generate(
                                        favoriteModel.favorites.length,
                                        (index) {
                                      return FavoriteGridItemWidget(
                                        heroTag: 'favorites_grid',
                                        favorite: favoriteModel.favorites
                                            .elementAt(index),
                                      );
                                    }),
                                  ),
                                )
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
