import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smn_delivery_app/const/widgets.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/customWidget/end_drawer.dart';
import 'package:smn_delivery_app/view/screens/map/map_nav_bar_screen.dart';
import 'package:smn_delivery_app/view/screens/messages/messages_nav_bar_screen.dart';
import 'package:smn_delivery_app/view/screens/order/orders_nav_bar_screen.dart';

import 'home_nav_bar_screen.dart';
import '../notifications/notification_nav_bar_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialPage;
  Address? restaurantAddress;

  HomeScreen({Key? key, required this.initialPage, this.restaurantAddress})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? currentBackPressTime;
  late AppLocalizations _trans;
  late PageController _pageController;

  late int _selectedIndex;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialPage);
    _selectedIndex = widget.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: const DrawerWidget(),
        endDrawer: const EndDrawer(),
        body: PageView(
            children: [
              const NotificationNavBarScreen(),
              MapNavBarScreen(restaurantAddress: widget.restaurantAddress),
              const HomeNavBarScreen(),
              const OrderNavBarScreen(),
              const MessagesNavBarScreen(),
            ],
            onPageChanged: (p) {
              setState(() {
                _selectedIndex = p;
              });
            },
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics()),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: _selectedIndex,
          onTap: (int i) {
            _onTappedBar(i);
          },
          // this will be set when a  tab is tapped
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.notifications),
                label: '',
                tooltip: _trans.notifications),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on),
                label: '',
                tooltip: _trans.maps_explorer),
            BottomNavigationBarItem(
                label: '',
                tooltip: _trans.home,
                icon: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4),
                          blurRadius: 40,
                          offset: const Offset(0, 15)),
                      BoxShadow(
                          color: Theme.of(context).accentColor.withOpacity(0.4),
                          blurRadius: 13,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child:
                      Icon(Icons.home, color: Theme.of(context).primaryColor),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood),
                label: '',
                tooltip: _trans.my_orders),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat), label: '', tooltip: _trans.messages),
          ],
        ),
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showToast(message: _trans.tapAgainToLeave, context: context);
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
}
