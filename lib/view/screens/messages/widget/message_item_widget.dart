import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';
import 'package:smn_delivery_app/data/messages/model/conversation.dart';
import 'package:smn_delivery_app/view_models/auth_view_model.dart';

class MessageItemWidget extends StatefulWidget {
  MessageItemWidget(
      {Key? key, required this.message, required this.onDismissed})
      : super(key: key);
  final Conversation message;
  final ValueChanged<Conversation> onDismissed;

  @override
  _MessageItemWidgetState createState() => _MessageItemWidgetState();
}

class _MessageItemWidgetState extends State<MessageItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.message.hashCode.toString()),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        // Remove the item from the data source.
        setState(() {
          widget.onDismissed(widget.message);
        });

        // Then show a snackbar.
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                "The conversation with ${widget.message.name} is dismissed")));
      },
      child: InkWell(
        onTap: () {
          // Navigator.of(context)
          //     .pushNamed('ChatScreen', arguments: widget.messages);

          Navigator.of(context).pushNamed(
            'ChatScreen',
            arguments: {
              'Conversation': widget.message,
              'restaurantId': ''
            },
          );
        },
        child: Consumer<AuthViewModel>(
          builder: (context, authModel, child) {
            return Container(
              color:
                 widget.message.readByUsers!.contains(authModel.user!.id)
                      ? Colors.transparent
                      : Theme.of(context).focusColor.withOpacity(0.05),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(60)),
                          child: CachedNetworkImage(
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            //TODO same user has kitchen
                            imageUrl:widget
                                .message
                                .users!
                                .firstWhere((element) =>
                                    element.id != authModel.user!.id)
                                .image
                                .thumb!,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 140,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        right: 3,
                        width: 12,
                        height: 12,
                        child: Container(
                          decoration: const BoxDecoration(
//                        color: widget.message.user.userState == UserState.available
//                            ? Colors.green
//                            : widget.message.user.userState == UserState.away ? Colors.orange : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget
                                        .message
                                        .users
                                        ?.firstWhere((element) =>
                                            element.id != authModel.user!.id)
                                        .name ??
                                    '',
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .merge(TextStyle(
                                        fontWeight: widget
                                                .message
                                                .readByUsers!
                                                .contains(authModel.user!.id)
                                            ? FontWeight.w400
                                            : FontWeight.w800)),
                              ),
                            ),
                            Text(
                              DateFormat('HH:mm').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      widget.message.lastMessageTime!,
                                      isUtc: false)),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.message.lastMessage!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .merge(TextStyle(
                                        fontWeight:widget
                                                .message
                                                .readByUsers!
                                                .contains(authModel.user!.id)
                                            ? FontWeight.w400
                                            : FontWeight.w800)),
                              ),
                            ),
                            Text(
                              DateFormat('dd-MM-yyyy').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      widget.message.lastMessageTime!,
                                      isUtc: true)),
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
