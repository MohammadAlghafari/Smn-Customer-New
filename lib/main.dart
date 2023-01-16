import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/data/order/model/order.dart';
import 'package:smn_delivery_app/injectionContaner.dart' as di;
import 'package:smn_delivery_app/smn_customer.dart';
import 'package:smn_delivery_app/utili/app_config.dart' as config;
import 'package:smn_delivery_app/utili/notification_service.dart';
import 'package:smn_delivery_app/view/screens/address/DeliveryAddressesScreen.dart';
import 'package:smn_delivery_app/view/screens/profile/ProfileWidget.dart';
import 'package:smn_delivery_app/view/screens/review/reviews_screen.dart';
import 'package:smn_delivery_app/view/screens/order/widget/TrackingWidget.dart';
import 'package:smn_delivery_app/view/screens/messages/widget/chat_screen.dart';
import 'package:smn_delivery_app/view/screens/auth/forget_password_screen.dart';
import 'package:smn_delivery_app/view/screens/auth/login_screen.dart';
import 'package:smn_delivery_app/view/screens/auth/signup_screen.dart';
import 'package:smn_delivery_app/view/screens/cart/cart_screen.dart';
import 'package:smn_delivery_app/view/screens/cart/delivery_pickup_screen.dart';
import 'package:smn_delivery_app/view/screens/cart/order_success_screen.dart';
import 'package:smn_delivery_app/view/screens/category/category_foods_screen.dart';
import 'package:smn_delivery_app/view/screens/faq_help/help_screen.dart';
import 'package:smn_delivery_app/view/screens/favorites/favorites_screen.dart';
import 'package:smn_delivery_app/view/screens/food/food_details_screen.dart';
import 'package:smn_delivery_app/view/screens/home/home_screen.dart';
import 'package:smn_delivery_app/view/screens/language/languages_screen.dart';
import 'package:smn_delivery_app/view/screens/restaurant/RestaurantDetailsScreen.dart';
import 'package:smn_delivery_app/view/screens/restaurant/all_restaurants_screen.dart';
import 'package:smn_delivery_app/view/screens/restaurant/restaurant_chat_nav_bar_screen.dart';
import 'package:smn_delivery_app/view/screens/settings/settings_screen.dart';
import 'package:smn_delivery_app/view/screens/splash.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/cart_view_model.dart';
import 'package:smn_delivery_app/view_models/category_view_model.dart';
import 'package:smn_delivery_app/view_models/faq_veiw_model.dart';
import 'package:smn_delivery_app/view_models/favorite_view_model.dart';
import 'package:smn_delivery_app/view_models/filter_view_model.dart';
import 'package:smn_delivery_app/view_models/home_view_model.dart';
import 'package:smn_delivery_app/view_models/messages_view_model.dart';
import 'package:smn_delivery_app/view_models/notifications_view_model.dart';
import 'package:smn_delivery_app/view_models/order_view_model.dart';
import 'package:smn_delivery_app/view_models/pickUp_delivery_view_model.dart';
import 'package:smn_delivery_app/view_models/restaurants_view_model.dart';
import 'package:smn_delivery_app/view_models/review_view_model.dart';
import 'package:smn_delivery_app/view_models/search_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Firebase.initializeApp");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationService.initializeNotifications();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => di.si<AuthViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<HomeViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<SettingViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<FaqViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<OrderViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<CartViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<FavoriteViewModel>()),
        ChangeNotifierProvider(
            create: (context) => di.si<PickupDeliveryViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<MessagesViewModel>()),
        ChangeNotifierProvider(
            create: (context) => di.si<RestaurantsViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<CategoryViewModel>()),
        ChangeNotifierProvider(
            create: (context) => di.si<NotificationsViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<FilterViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<SearchViewModel>()),
        ChangeNotifierProvider(create: (context) => di.si<ReviewViewModel>()),
      ],
      child: Consumer<SettingViewModel>(
        builder: (context, settings, child) {
          return MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: settings.setting.mobileLanguage,
            supportedLocales: const [
              Locale("ar", ''),
              Locale("en", ''),
            ],
            home: const Scaffold(body: SplashScreen()),
            theme: settings.setting.brightness == Brightness.light
                ? ThemeData(
                    // fontFamily: 'MyriadPro',
                    primaryColor: Colors.white,
                    appBarTheme: const AppBarTheme(
                      iconTheme: IconThemeData(
                        color: Colors.black,
                      ),
                    ),
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                            elevation: 0, foregroundColor: Colors.white),
                    brightness: Brightness.light,
                    accentColor: config.Colors(context).mainColor(1),
                    dividerColor: config.Colors(context).accentColor(0.1),
                    focusColor: config.Colors(context).accentColor(1),
                    hintColor: config.Colors(context).secondColor(1),
                    primarySwatch: Colors.deepOrange,
                    textTheme: TextTheme(
                      headline5: TextStyle(
                          fontSize: 20.0,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      headline4: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      headline3: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      headline2: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors(context).mainColor(1),
                          height: 1.35),
                      headline1: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                          color: config.Colors(context).secondColor(1),
                          height: 1.5),
                      subtitle1: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      headline6: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).mainColor(1),
                          height: 1.35),
                      bodyText2: TextStyle(
                          fontSize: 12.0,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      bodyText1: TextStyle(
                          fontSize: 14.0,
                          color: config.Colors(context).secondColor(1),
                          height: 1.35),
                      caption: TextStyle(
                          fontSize: 12.0,
                          color: config.Colors(context).accentColor(1),
                          height: 1.35),
                    ),
                  )
                : ThemeData(
                    // fontFamily: 'MyriadPro',
                    primaryColor: const Color(0xFF252525),
                    brightness: Brightness.dark,
                    scaffoldBackgroundColor: const Color(0xFF2C2C2C),
                    accentColor: config.Colors(context).mainDarkColor(1),
                    dividerColor: config.Colors(context).accentColor(0.1),
                    hintColor: config.Colors(context).secondDarkColor(1),
                    focusColor: config.Colors(context).accentDarkColor(1),
                    primarySwatch: Colors.deepOrange,
                    textTheme: TextTheme(
                      headline5: TextStyle(
                          fontSize: 20.0,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      headline4: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      headline3: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      headline2: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w700,
                          color: config.Colors(context).mainDarkColor(1),
                          height: 1.35),
                      headline1: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.5),
                      subtitle1: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      headline6: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: config.Colors(context).mainDarkColor(1),
                          height: 1.35),
                      bodyText2: TextStyle(
                          fontSize: 12.0,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      bodyText1: TextStyle(
                          fontSize: 14.0,
                          color: config.Colors(context).secondDarkColor(1),
                          height: 1.35),
                      caption: TextStyle(
                          fontSize: 12.0,
                          color: config.Colors(context).secondDarkColor(0.6),
                          height: 1.35),
                    ),
                  ),
            onGenerateRoute: (settings) {
              var view;
              switch (settings.name) {
                case "HomeScreen":
                  view = HomeScreen(
                    initialPage: (settings.arguments as Map)['initialPage'],
                    restaurantAddress:
                        (settings.arguments as Map)['restaurantAddress'],
                  );
                  break;
                case "SignupScreen":
                  view = const SignupScreen();
                  break;
                case "DeliveryPickupScreen":
                  view = const DeliveryPickupScreen();
                  break;
                case "ProfileWidget":
                  view = const ProfileWidget();
                  break;
                case "AllRestaurantsScreen":
                  view = const AllRestaurantsScreen();
                  break;
                case "LoginScreen":
                  view =  LoginScreen();
                  break;
                case "ForgetPassword":
                  view = const ForgetPasswordScreen();
                  break;
                case "RestaurantDetailsScreen":
                  view = RestaurantDetailsScreen(
                    restaurantId: settings.arguments as String,
                  );
                  break;
                case "ReviewsScreen":
                  view = ReviewsScreen(
                    order: settings.arguments as Order,
                  );
                  break;
                case "ChatRestaurantNavBarScreen":
                  view = RestaurantChatNavBarScreen(
                    restaurantId: settings.arguments as String,
                  );
                  break;
                case "TrackingWidget":
                  view = TrackingWidget(
                     order: settings.arguments as Order,
                  );
                  break;
                case "FoodDetailsScreen":
                  view = FoodDetailsScreen(
                    food: settings.arguments as Food,
                  );
                  break;
                case "HelpScreen":
                  view = const HelpScreen();
                  break;
                case "LanguagesScreen":
                  view = LanguagesScreen();
                  break;
                case "SettingsScreen":
                  view = const SettingsScreen();
                  break;
                case "FavoritesScreen":
                  view = const FavoritesScreen();
                  break;
                case "DeliveryAddressesScreen":
                  view =  DeliveryAddressesScreen();
                  break;
                case "CartScreen":
                  view = const CartScreen();
                  break;
                case "OrderSuccessScreen":
                  view = OrderSuccessScreen(
                    defaultTax: (settings.arguments as Map)['defaultTax'],
                    deliveryFee: (settings.arguments as Map)['deliveryFee'],
                    subTotalWithoutCoupon: (settings.arguments as Map)['subTotalWithoutCoupon'],
                    paymentMethod: (settings.arguments as Map)['paymentMethod'],
                    subtotal: (settings.arguments as Map)['subtotal'],
                    taxAmount: (settings.arguments as Map)['taxAmount'],
                    total: (settings.arguments as Map)['total'],
                  );
                  break;
                case 'ChatScreen':
                  view = ChatScreen(
                    conversation: (settings.arguments as Map)['Conversation']
                        as Conversation,
                    restaurantId:
                        (settings.arguments as Map)['restaurantId'] as String,
                  );
                  break;
                case "CategoryFoodsScreen":
                  view = CategoryFoodsScreen(
                    category: settings.arguments as Category,
                  );
                  break;
              }
              return MaterialPageRoute(
                  builder: (context) => view, settings: settings);
            },
          );
        },
      ),
    );
  }
}

//C:\Program Files\Java\jdk-11.0.14\bin
//F1:DB:8F:0C:B5:E5:EB:8D:16:FE:37:69:64:D2:1E:8C:33:A8:15:D2:C6:D7:89:34:39:6D:DF:4F:99:F9:75:44
//keytool -list -v -alias androiddebugkey -keystore C:\Users\Mohamad\.android\debug.keystore
