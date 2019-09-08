import 'package:flutter/material.dart';
import 'package:myfootball/blocs/chat-bloc.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';

// ignore: must_be_immutable
class ChatPage extends BasePage<ChatBloc> {
  @override
  AppBarWidget buildAppBar(BuildContext context) => AppBarWidget(
        centerContent: Text(
          "Chat",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.title,
        ),
      );

  @override
  Widget buildLoading(BuildContext context) => null;

  @override
  Widget buildMainContainer(BuildContext context) {
    return Container(
      child: Text("chat"),
    );
  }

  @override
  void listenData(BuildContext context) {}
}
