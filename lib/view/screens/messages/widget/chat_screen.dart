import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/auth/model/user.dart';
import 'package:smn_delivery_app/data/messages/model/chat.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view/screens/messages/widget/EmptyMessagesWidget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/messages_view_model.dart';
import 'package:smn_delivery_app/view_models/setting_view_model.dart';

import 'ChatMessageListItem.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {Key? key, required this.conversation, required this.restaurantId})
      : super(key: key);
  final Conversation conversation;
  final String restaurantId;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _myListKey = GlobalKey<AnimatedListState>();
  final myController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  int listLength = 0;
  late AppLocalizations _trans;

  @override
  void initState() {
    Provider.of<MessagesViewModel>(context, listen: false).conversation =
        widget.conversation;
    if (Provider.of<MessagesViewModel>(context, listen: false)
                .conversation!
                .id !=
            null &&
        Provider.of<MessagesViewModel>(context, listen: false)
            .conversation!
            .id!
            .isNotEmpty) {
      Provider.of<MessagesViewModel>(context, listen: false).listenForChats(
          Provider.of<MessagesViewModel>(context, listen: false).conversation!);
    } else {
      // Provider.of<MessagesViewModel>(context, listen: false)
      //     .createConversation(widget.conversation);
    }
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget chatList(MessagesViewModel messagesViewModel) {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesViewModel.chats,
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
                  Chat _chat = Chat.fromJSON(snapshot.data!.docs[index].data()
                      as Map<String, dynamic>);

                  _chat.user = messagesViewModel.conversation!.users!
                      .firstWhere((_user) => _user.id == _chat.userId,
                          orElse: () => User.fromJSON({}));
                  if (messagesViewModel.loadingChats) {
                    return CircularLoadingWidget(height: 200);
                  }

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
    return Consumer<MessagesViewModel>(
      builder: (context, messagesModel, child) {
        if (messagesModel.loadingChats &&
            Provider.of<MessagesViewModel>(context, listen: false)
                .conversation!
                .id!
                .isNotEmpty) {
          return Scaffold(
              body: Center(child: CircularLoadingWidget(height: 200)));
        }
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              messagesModel.conversation!.name!,
              overflow: TextOverflow.fade,
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .merge(const TextStyle(letterSpacing: 1.3)),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: Theme.of(context).hintColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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
                child: chatList(messagesModel),
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
                    suffixIcon: Consumer<SettingViewModel>(
                      builder: (context, settingModel, child) {
                        return IconButton(
                          padding: EdgeInsets.only(
                              right: settingModel.setting.mobileLanguage
                                          .languageCode ==
                                      'en'
                                  ? 30
                                  : 0,
                              left: settingModel.setting.mobileLanguage
                                          .languageCode ==
                                      'en'
                                  ? 0
                                  : 30),
                          onPressed: () {
                            if (myController.text.trim().isNotEmpty) {
                              messagesModel.addMessage(
                                  messagesModel.conversation!,
                                  myController.text,
                                  listLength,
                                  widget.restaurantId);
                            }
                            Timer(const Duration(milliseconds: 10), () {
                              myController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).accentColor,
                            size: 30,
                          ),
                        );
                      },
                    ),
                    border:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
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
}
