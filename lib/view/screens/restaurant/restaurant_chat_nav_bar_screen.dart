import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/messages/model/chat.dart';
import 'package:smn_delivery_app/view/screens/messages/widget/ChatMessageListItem.dart';
import 'package:smn_delivery_app/view/screens/messages/widget/EmptyMessagesWidget.dart';
import 'package:smn_delivery_app/view/customWidget/PermissionDeniedWidget.dart';
import 'package:smn_delivery_app/view/customWidget/loading_progress_indicator.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/messages_view_model.dart';
import 'package:smn_delivery_app/view_models/restaurants_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

class RestaurantChatNavBarScreen extends StatefulWidget {
  String restaurantId;

  RestaurantChatNavBarScreen({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RestaurantChatNavBarScreenState createState() =>
      _RestaurantChatNavBarScreenState();
}

class _RestaurantChatNavBarScreenState
    extends State<RestaurantChatNavBarScreen> {
  final _myListKey = GlobalKey<AnimatedListState>();
  final myController = TextEditingController();
  late AppLocalizations _trans;
  int listLength = 0;
  var res = 0;

  @override
  void initState() {
    Provider.of<MessagesViewModel>(context, listen: false)
        .initialConversation(Provider.of<RestaurantsViewModel>(context,listen: false).restaurant);
    super.initState();
  }

  Widget chatList(MessagesViewModel messageModel) {
    return StreamBuilder<QuerySnapshot>(
      stream: messageModel.chats,
      builder: (context, snapshot) {
        listLength = snapshot.hasData ? snapshot.data!.docs.length : 0;
        return snapshot.hasData
            ? ListView.builder(
                key: _myListKey,
                reverse: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: false,
                primary: true,
                itemBuilder: (context, index) {
                  print(snapshot.data!.docs[index].data());
                  Chat _chat = Chat.fromJSON(
                      snapshot.data!.docs[index].data() as dynamic);
                  _chat.user = messageModel.conversation!.users!
                      .firstWhere((_user) => _user.id == _chat.userId);
                  return Consumer2<SettingViewModel, AuthViewModel>(
                    builder: (context, settingsModel, userModel, child) {
                      return ChatMessageListItem(
                        chat: _chat,
                        setting: settingsModel.setting,
                        user: userModel.user!,
                      );
                    },
                  );
                })
            : EmptyMessagesWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;

    return Consumer2<MessagesViewModel, AuthViewModel>(
      builder: (context, messageModel, authModel, child) {
        if (authModel.user == null) return PermissionDeniedWidget();
        if (messageModel.loadingConversation) {
          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                  height: 200,
                  child: Center(child: LoadingProgressIndicator())),
            ],
          ));
        }
        return Scaffold(
          // key: restaurantsRepo.scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
                icon:
                    Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            automaticallyImplyLeading: false,
            title: Text(
              messageModel.conversation!=null ?messageModel.conversation!.name!: '', //TODO
              overflow: TextOverflow.fade,
              maxLines: 1,
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
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: chatList(messageModel),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).hintColor.withOpacity(0.10),
                        offset: const Offset(0, -4),
                        blurRadius: 10)
                  ],
                ),
                child: TextField(
                  autocorrect: false,
                  controller: myController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    hintText: _trans.typeToStartChat,
                    hintStyle: TextStyle(
                        color: Theme.of(context).focusColor.withOpacity(0.8)),
                    suffixIcon: IconButton(
                      padding: EdgeInsets.only(
                          right: Localizations.localeOf(context).languageCode ==
                                  'en'
                              ? 30
                              : 0,
                          left: Localizations.localeOf(context).languageCode ==
                                  'en'
                              ? 0
                              : 30),
                      onPressed: () {
                        // restaurantModel.addMessage(restaurantModel.conversation, myController.text,
                        //     listLength, widget.routeArgument.id);
                        Provider.of<MessagesViewModel>(context, listen: false)
                            .addMessage(
                                messageModel.conversation,
                                myController.text,
                                listLength,
                                messageModel.restaurant!.id,restaurant: messageModel.restaurant);
                        Timer(const Duration(milliseconds: 10), () {
                          myController.clear();
                        });
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      ),
                    ),
                    border: const UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }
}

