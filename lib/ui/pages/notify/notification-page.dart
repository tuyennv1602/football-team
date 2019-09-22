import 'package:myfootball/blocs/noti-bloc.dart';
import 'package:myfootball/models/notification.dart' as noti;
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base-page.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/line.dart';

// ignore: must_be_immutable
class NotificationPage extends BasePage<NotiBloc> {
  final FAKE_NOTI = [
    noti.Notification(id: 1, title: 'Notification 1', content: 'test test'),
    noti.Notification(id: 2, title: 'Notification 2', content: 'test test'),
    noti.Notification(id: 3, title: 'Notification 3', content: 'test test'),
    noti.Notification(id: 4, title: 'Notification 4', content: 'test test'),
    noti.Notification(id: 5, title: 'Notification 5', content: 'test test'),
    noti.Notification(id: 6, title: 'Notification 6', content: 'test test'),
  ];

  @override
  Widget buildAppBar(BuildContext context) {
    return AppBarWidget(
      centerContent: Text(
        "Thông báo",
        textAlign: TextAlign.center,
        style: textStyleTitle(),
      ),
      rightContent: AppBarButtonWidget(
        imageName: Images.CLEAR,
        onTap: () {},
      ),
    );
  }

  Widget _buildItemNotification(
          BuildContext context, noti.Notification notification) =>
      InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size20, vertical: size10),
          child: Row(
            children: <Widget>[
              Container(
                width: size10,
                height: size10,
                margin: EdgeInsets.only(right: size20),
                decoration: BoxDecoration(
                    color: PRIMARY,
                    borderRadius: BorderRadius.circular(size5),
                    boxShadow: [
                      BoxShadow(
                          color: SHADOW_GREEN,
                          offset: Offset(0, 0),
                          blurRadius: size5,
                          spreadRadius: size5)
                    ]),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      notification.title,
                      style: textStyleSemiBold(),
                    ),
                    Text(
                      notification.content,
                      maxLines: 3,
                      style: textStyleRegular(size: 16),
                    ),
                    Text(
                      notification.getCreateTime,
                      style: textStyleItalic(color: Colors.grey),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget buildMainContainer(BuildContext context) {
    return BorderBackground(
        child: ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: size10),
            itemBuilder: (c, index) =>
                _buildItemNotification(context, FAKE_NOTI[index]),
            separatorBuilder: (c, index) => LineWidget(),
            itemCount: FAKE_NOTI.length));
  }

  @override
  void listenData(BuildContext context) {}
}
