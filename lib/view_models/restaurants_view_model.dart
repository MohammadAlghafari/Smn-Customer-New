import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smn_delivery_app/data/auth/model/address.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/home/model/category.dart';
import 'package:smn_delivery_app/data/home/model/food.dart';
import 'package:smn_delivery_app/data/messages/model/chat.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/data/restaurants/model/gallery.dart';
import 'package:smn_delivery_app/data/restaurants/model/restaurant.dart';
import 'package:smn_delivery_app/data/restaurants/restaurents_repo.dart';
import 'package:smn_delivery_app/data/review/model/review.dart';
import 'package:smn_delivery_app/utili/helper.dart';
import 'package:smn_delivery_app/utili/maps_util.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

import '../smn_customer.dart';

class RestaurantsViewModel extends ChangeNotifier {
  SettingViewModel settingViewModel;
  bool loadingDataRestaurants = true;
  bool loadingFeaturedFoods = true;
  bool loadingReviews = true;
  bool loadingGalleries = true;
  bool loadingRestaurant = true;
  bool loadingConversation = true;
  Restaurant? restaurant;
  RestaurantsRepo restaurantsRepo;
  AuthViewModel authViewModel;
  List<Food> featuredFoods = <Food>[];
  List<Food> trendingFoods = <Food>[];
  List<Gallery> galleries = <Gallery>[];
  List<Review> reviews = <Review>[];
  List<Category> categories = <Category>[];
  List<Food> foods = <Food>[];

  RestaurantsViewModel(
      {required this.restaurantsRepo,
      required this.authViewModel,
      required this.settingViewModel});

  // void listenForRestaurants({String? messages}) async {
  //   restaurants.clear();
  //   loadingDataRestaurants = true;
  //   restaurants= await restaurantsRepo.getRestaurants();
  //   loadingDataRestaurants = false;
  //   notifyListeners();
  // }

  // Future<void> refreshRestaurants() async {
  //   restaurants.clear();
  //   listenForRestaurants(
  //       messages:
  //           AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
  //               .restaurant_refreshed_successfuly);
  // }

  Future<void> refreshRestaurant() async {
    var _id = restaurant!.id;
    restaurant = Restaurant.fromJSON({});
    galleries.clear();
    reviews.clear();
    featuredFoods.clear();
    listenForRestaurant(
        id: _id,
        message:
            AppLocalizations.of(NavigationService.navigatorKey.currentContext!)!
                .restaurant_refreshed_successfuly);
    listenForRestaurantReviews(id: _id);
    listenForGalleries(_id);
    listenForFeaturedFoods(_id);
  }

  Future<void> listenForRestaurant(
      {required String id, String? message}) async {
    restaurant = await restaurantsRepo.getRestaurant(id);
    // getRestaurantLocation();
    loadingRestaurant = false;
    notify();
  }

  Future<void> listenForGalleries(String idRestaurant) async {
    galleries = [];

    galleries = await restaurantsRepo.getGalleries(idRestaurant);
    loadingGalleries = false;
    notify();
  }

  Future<void> listenForRestaurantReviews(
      {required String id, String? message}) async {
    reviews = await restaurantsRepo.getRestaurantReviews(id);
    loadingReviews = false;
    notify();
  }

  Future<void> listenForFeaturedFoods(String idRestaurant) async {
    featuredFoods = [];
    featuredFoods =
        await restaurantsRepo.getFeaturedFoodsOfRestaurant(idRestaurant);
    loadingFeaturedFoods = false;
    notify();
  }

  Future<void> listenForTrendingFoods(String idRestaurant) async {
    trendingFoods =
        await restaurantsRepo.getTrendingFoodsOfRestaurant(idRestaurant);
    notifyListeners();
  }

  Future<void> listenForCategories(String restaurantId) async {
    categories = await restaurantsRepo.getCategoriesOfRestaurant(restaurantId);
    categories.insert(
        0,
        Category.fromJSON({
          'id': '0',
          'name': AppLocalizations.of(
                  NavigationService.navigatorKey.currentContext!)!
              .all
        }));
    notifyListeners();
  }

  void listenForFoods(String idRestaurant, {List<String>? categoriesId}) async {
    foods = await restaurantsRepo.getFoodsOfRestaurant(idRestaurant,
        categories: categoriesId);
    notifyListeners();
  }

  Future<void> selectCategory(List<String> categoriesId) async {
    foods.clear();
    listenForFoods(restaurant!.id, categoriesId: categoriesId);
  }

  Future<void> init(String id) async {
    featuredFoods.clear();
    restaurant = null;
    galleries.clear();
    reviews.clear();
    loadingReviews = true;
    loadingFeaturedFoods = true;
    loadingGalleries = true;
    loadingRestaurant = true;
    listenForRestaurant(id: id);
    listenForCategories(id);
    listenForGalleries(id);
    listenForFeaturedFoods(id);
    listenForFoods(id);
    listenForRestaurantReviews(id: id);
  }

  void notify() {
    if (!(loadingReviews ||
        loadingFeaturedFoods ||
        loadingGalleries ||
        loadingRestaurant)) notifyListeners();
  }

  bool isLoadingRestaurant() {
    return loadingReviews ||
        loadingFeaturedFoods ||
        loadingGalleries ||
        loadingRestaurant;
  }

  ///Map
  List<Restaurant> topRestaurants = <Restaurant>[];
  List<Marker> allMarkers = <Marker>[];
  Address? currentAddress;
  CameraPosition? cameraPosition;
  MapsUtil mapsUtil = MapsUtil();
  Completer<GoogleMapController> mapController = Completer();

  void listenForNearRestaurants(
      Address myLocation, Address areaLocation) async {
    topRestaurants =
        await restaurantsRepo.getNearRestaurants(myLocation, areaLocation);
    for (var element in topRestaurants) {
      Helper.getMarker(element.toMap(), settingViewModel.setting)
          .then((marker) {
        allMarkers.add(marker);
        notifyListeners();
      });
    }
  }

  void getCurrentLocation(Address? restaurantAddress) async {
    allMarkers.clear();
    try {
      currentAddress = await settingViewModel.getCurrentLocationSetting();
      if (currentAddress!.isUnknown()) {
        cameraPosition = const CameraPosition(
          target: LatLng(40, 3),
          zoom: 4,
        );
      } else {
        if (restaurantAddress == null) {
          cameraPosition = CameraPosition(
            target: LatLng(currentAddress!.latitude, currentAddress!.longitude),
            zoom: 14.4746,
          );
        } else {
          cameraPosition = CameraPosition(
            target:
                LatLng(restaurantAddress.latitude, restaurantAddress.longitude),
            zoom: 14.4746,
          );
        }
      }
      if (!currentAddress!.isUnknown()) {
        await Helper.getMyPositionMarker(
                currentAddress!.latitude, currentAddress!.longitude)
            .then((marker) {
          allMarkers.add(marker);
          notifyListeners();
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

//
  void getRestaurantLocation() async {
    allMarkers.clear();
    try {
      currentAddress = await settingViewModel.getCurrentLocationSetting();
      cameraPosition = CameraPosition(
        target: LatLng(double.parse(restaurant!.latitude),
            double.parse(restaurant!.longitude)),
        zoom: 14.4746,
      );
      if (currentAddress != null) {
        await Helper.getMyPositionMarker(
                currentAddress!.latitude, currentAddress!.longitude)
            .then((marker) {
          allMarkers.add(marker);
          notifyListeners();
        });
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;
    currentAddress = await settingViewModel.setCurrentLocation();
    if (currentAddress == null) return;
    // cameraPosition = CameraPosition(
    //   target: LatLng(double.parse(restaurant!.latitude),
    //       double.parse(restaurant!.longitude)),
    //   zoom: 14.4746,
    // );
    // notifyListeners();

    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentAddress!.latitude, currentAddress!.longitude),
      zoom: 14.4746,
    )));
    controller.dispose();
  }

  void getRestaurantsOfArea() async {
    topRestaurants = <Restaurant>[];
    if (cameraPosition != null) {
      Address areaAddress = Address.fromJSON({
        "latitude": cameraPosition!.target.latitude,
        "longitude": cameraPosition!.target.longitude
      });
      listenForNearRestaurants(currentAddress!, areaAddress);
    } else {
      listenForNearRestaurants(currentAddress!, currentAddress!);
    }
  }

  // void getDirectionSteps() async {
  //   currentAddress = await settingViewModel.getCurrentLocationSetting();
  //   mapsUtil
  //       .get("origin=" +
  //           currentAddress!.latitude.toString() +
  //           "," +
  //           currentAddress!.longitude.toString() +
  //           "&destination=" +
  //           restaurant!.latitude +
  //           "," +
  //           restaurant!.longitude +
  //           "&key=${settingViewModel.setting.googleMapsKey}")
  //       .then((dynamic res) {
  //     if (res != null) {
  //       List<LatLng> _latLng = res as List<LatLng>;
  //       _latLng.insert(
  //           0, LatLng(currentAddress!.latitude, currentAddress!.longitude));
  //       // setState(() {
  //       //   polylines.add(new Polyline(
  //       //       visible: true,
  //       //       polylineId: new PolylineId(currentAddress.hashCode.toString()),
  //       //       points: _latLng,
  //       //       color: config.Colors().mainColor(0.8),
  //       //       width: 6));
  //       // });
  //     }
  //   });
  // }

  Future refreshMap() async {
    topRestaurants = <Restaurant>[];
    listenForNearRestaurants(currentAddress!, currentAddress!);
  }

  ///Chat

  late Stream<QuerySnapshot> conversations;
  Stream<QuerySnapshot>? chats;
  Conversation? conversation;

  createConversation(Conversation _conversation) async {
    _conversation.lastMessageTime =
        DateTime.now().toUtc().millisecondsSinceEpoch;
    _conversation.id = UniqueKey().toString();
    conversation = _conversation;
    notifyListeners();
    restaurantsRepo.createConversation(conversation!).then((value) {
      listenForChats(_conversation);
    });
  }

  listenForConversations() async {
    restaurantsRepo
        .getUserConversations(authViewModel.user!.id!)
        .then((snapshots) {
      conversations = snapshots;
      notifyListeners();
    });
  }

  listenForChats(Conversation _conversation) async {
    _conversation.readByUsers?.add(authViewModel.user!.id!);
    if (_conversation.lastMessage!.isEmpty) return;
    restaurantsRepo.getChats(_conversation).then((snapshots) {
      chats = snapshots;
      loadingConversation = false;
      notifyListeners();
    });
  }

  addMessage(
      Conversation _conversation, String text, int len, String restaurantId) {
    Chat _chat = Chat.fromJSON({
      "text": text,
      "time": DateTime.now().toUtc().millisecondsSinceEpoch,
      "userId": authViewModel.user!.id!
    });
    if (_conversation.id == null) {
      _conversation.id = UniqueKey().toString();
      createConversation(_conversation);
    }
    _conversation.lastMessage = text;
    _conversation.lastMessageTime = _chat.time;
    _conversation.readByUsers = [authViewModel.user!.id!];
    restaurantsRepo.addMessage(_conversation, _chat).then((value) {
      _conversation.users!.forEach((_user) async {
        if (_user.id != authViewModel.user!.id!) {
          /// set data of messages on php host
          // if (len == 0 || len == null) {
          //   print("not chat found");
          //   await setChatInfo("${restaurantId}", "${authViewModel.user!.id!}",
          //       "${_conversation.id}");
          // }
          // await setChatMessageInfo("$text", restaurantId, _conversation.id,
          //     authViewModel.user!.id!.toString(), "1");
          // sendNotification(
          //     text,
          //     S.of(context).newMessageFrom + " " + authViewModel.user!.name,
          //     _user);
        }
      });
    });
  }


  orderSnapshotByTime(AsyncSnapshot snapshot) {
    final docs = snapshot.data.documents;
    docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
      var time1 = a.get('time');
      var time2 = b.get('time');
      return time2.compareTo(time1) as int;
    });
    return docs;
  }

  initialConversation(String restaurantId) async {
    loadingConversation = true;
    List<String> chatOwners = [];
    for (int i = 0; i < restaurant!.users.length; i++) {
      chatOwners.add(restaurant!.users[i].id!);
    }
    if (authViewModel.user == null) return;
    chatOwners.add(authViewModel.user!.id!);
    List<User> users = restaurant!.users.map((e) {
      e.image = restaurant!.image;
      return e;
    }).toList();
    users.add(authViewModel.user!);
    var id = await restaurantsRepo.getConversation(chatOwners);
    if (id == null || id.isEmpty) {
      // await createConversation(Conversation.fromJSONRestaurant(
      //     {"users": users, "name": restaurant!.name, "id": id}));
      // listenForChats(conversation);
      loadingConversation = false;
      notifyListeners();
    } else {
      conversation = Conversation.fromJSONRestaurant(
          {"users": users, "name": restaurant!.name, "id": id,'messages':'messages'});
      listenForChats(conversation!);
    }
  }
}
