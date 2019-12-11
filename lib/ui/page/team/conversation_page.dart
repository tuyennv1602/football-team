import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/utils/date_util.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ConversationState();
}

class _ConversationState extends State<ConversationPage> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  void onSend(ChatMessage message, int teamId) {
    var documentReference = Firestore.instance
        .collection('team')
        .document('$teamId')
        .collection('messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());
    Firestore.instance.runTransaction(
      (transaction) async {
        await transaction.set(
          documentReference,
          message.toJson(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<User>(context);
    var _team = Provider.of<Team>(context);
    var user = ChatUser(
      name: _user.name,
      uid: _user.id.toString(),
      avatar: _user.avatar,
    );
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Thảo luận',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('team')
                    .document('${_team.id}')
                    .collection('messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingWidget();
                  } else {
                    List<DocumentSnapshot> items = snapshot.data.documents;
                    var messages =
                        items.map((i) => ChatMessage.fromJson(i.data)).toList();
                    Timer(Duration(milliseconds: 300), () {
                      _chatViewKey.currentState.scrollController
                        ..animateTo(
                          _chatViewKey.currentState.scrollController.position
                              .maxScrollExtent - UIHelper.size10,
                          curve: Curves.linear,
                          duration: const Duration(milliseconds: 300),
                        );
                    });
                    return DashChat(
                      key: _chatViewKey,
                      inverted: false,
                      onSend: (message) => onSend(message, _team.id),
                      user: user,
                      dateFormat: DateFormat('dd/MM/yyyy'),
                      messages: messages,
                      inputMaxLines: 1,
                      alwaysShowSend: true,
                      scrollToBottom: false,
                      shouldShowLoadEarlier: false,
                      onLoadEarlier: () {},
                      avatarBuilder: (user) => ImageWidget(
                          source: user.avatar,
                          placeHolder: Images.DEFAULT_AVATAR,
                          size: UIHelper.size30,
                          radius: UIHelper.size15),
                      messageContainerPadding:
                          EdgeInsets.only(bottom: UIHelper.size10),
                      messageBuilder: (message) {
                        var _isMine = message.user.uid == _user.id.toString();
                        return Container(
                          padding: EdgeInsets.all(UIHelper.size10),
                          margin: EdgeInsets.only(top: UIHelper.size5),
                          decoration: BoxDecoration(
                            color: _isMine ? PRIMARY : LINE_COLOR,
                            borderRadius:
                                BorderRadius.circular(UIHelper.padding),
                          ),
                          child: Column(
                            crossAxisAlignment: _isMine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(bottom: 3),
                                child: Text(
                                  message.text,
                                  style: textStyleRegular(
                                      color: _isMine
                                          ? Colors.white
                                          : Colors.black87),
                                ),
                              ),
                              Text(
                                DateUtil.getMessageTime(message.createdAt),
                                style: textStyleItalic(
                                    size: 11,
                                    color:
                                        _isMine ? Colors.white54 : Colors.grey),
                              )
                            ],
                          ),
                        );
                      },
                      inputToolbarPadding:
                          EdgeInsets.only(bottom: UIHelper.paddingBottom),
                      inputDecoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        hintStyle: textStyleMedium(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: UIHelper.padding,
                        ),
                      ),
                      inputTextStyle: textStyleMediumTitle(),
                      inputContainerStyle: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: SHADOW_GREY,
                              blurRadius: 1,
                              offset: Offset(0, -1)),
                        ],
                      ),
                      inputCursorColor: PRIMARY,
                      sendButtonBuilder: (send) => InkWell(
                        onTap: send,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: UIHelper.size15,
                              vertical: UIHelper.size10),
                          child: Image.asset(
                            Images.SEND,
                            width: UIHelper.size25,
                            height: UIHelper.size25,
                            color: PRIMARY,
                          ),
                        ),
                      ),
                      dateBuilder: (date) => Container(
                        margin: EdgeInsets.symmetric(vertical: UIHelper.size10),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: LineWidget()),
                            Text(
                              date,
                              style: textStyleMedium(color: Colors.grey),
                            ),
                            Expanded(child: LineWidget())
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
