import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/view/customWidget/Circular_loading_widget.dart';
import 'package:smn_delivery_app/view/screens/messages/widget/EmptyMessagesWidget.dart';
import 'package:smn_delivery_app/view/customWidget/PermissionDeniedWidget.dart';
import 'package:smn_delivery_app/view/customWidget/drawer_widget.dart';
import 'package:smn_delivery_app/view/screens/messages/widget/message_item_widget.dart';
import 'package:smn_delivery_app/view/screens/cart/widget/shopping_cart_button_widget.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';
import 'package:smn_delivery_app/view_models/messages_view_model.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MessagesNavBarScreen extends StatefulWidget {
  const MessagesNavBarScreen({Key? key}) : super(key: key);

  @override
  _MessagesNavBarScreenState createState() => _MessagesNavBarScreenState();
}

class _MessagesNavBarScreenState extends State<MessagesNavBarScreen> {
  late AppLocalizations _trans;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<MessagesViewModel>(context,listen: false).listenForConversations();
    super.initState();
  }

  Widget conversationsList(MessagesViewModel messagesViewModel) {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesViewModel.conversations,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // var _docs = messagesViewModel.orderSnapshotByTime(snapshot);
          // var _docs = snapshot.data!.docs;
          // print(snapshot.data!.docs[0].data());
          // snapshot.data!.docs.sort((QueryDocumentSnapshot a, QueryDocumentSnapshot b) {
          //   var time1 = a.get('time');
          //   var time2 = b.get('time');
          //   return time2.compareTo(time1) as int;
          // });
          return ListView.separated(
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                Conversation _conversation =
                Conversation.fromJSON(snapshot.data!.docs[index].data()as Map<String,dynamic>);
                return MessageItemWidget(
                  message: _conversation,
                  onDismissed: (conversation) async {
                    setState(() {
                      snapshot.data!.docs.removeAt(index);
                    });
                    await messagesViewModel.removeConversation(conversation.id!);
                  },
                );
              });
        } else {
          return EmptyMessagesWidget();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _trans = AppLocalizations.of(context)!;
    return Scaffold(
        key: scaffoldKey,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        leading: IconButton(
          tooltip: _trans.menu,
          icon:  Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => scaffoldKey.currentState!.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _trans.messages,
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
              labelColor: Theme.of(context).colorScheme.secondary),
        ],
      ),
      body: Consumer2<MessagesViewModel,AuthViewModel>(builder: (context, messagesModel,authModel, child) {
        if(authModel.user==null)return PermissionDeniedWidget();
        if(messagesModel.loadingConversations) {
          return CircularLoadingWidget(height: 500);
        }
        return ListView(
          primary: false,
          children: <Widget>[
            conversationsList(messagesModel),
          ],
        );
      },),
    );
  }
}
