import 'package:myfootball/models/notification.dart' as noti;
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui-helper.dart';

// ignore: must_be_immutable
class NotificationPage extends StatelessWidget {
  final FAKE_NOTI = [
    noti.Notification(id: 1, title: 'Notification 1', content: 'test test'),
    noti.Notification(id: 2, title: 'Notification 2', content: 'test test'),
    noti.Notification(id: 3, title: 'Notification 3', content: 'test test'),
    noti.Notification(id: 4, title: 'Notification 4', content: 'test test'),
    noti.Notification(id: 5, title: 'Notification 5', content: 'test test'),
    noti.Notification(id: 6, title: 'Notification 6', content: 'test test'),
  ];

  Widget _buildItemNotification(
          BuildContext context, noti.Notification notification) =>
      InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.size20, vertical: UIHelper.size10),
          child: Row(
            children: <Widget>[
              Container(
                width: UIHelper.size10,
                height: UIHelper.size10,
                margin: EdgeInsets.only(right: UIHelper.size20),
                decoration: BoxDecoration(
                    color: PRIMARY,
                    borderRadius: BorderRadius.circular(UIHelper.size5),
                    boxShadow: [
                      BoxShadow(
                          color: SHADOW_GREEN,
                          offset: Offset(0, 0),
                          blurRadius: UIHelper.size5,
                          spreadRadius: UIHelper.size5)
                    ]),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: notification.title,
                            style: textStyleRegularTitle(),
                          ),
                          TextSpan(
                            text: ' (${notification.getCreateTime})',
                            style: textStyleRegularBody(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      notification.content,
                      maxLines: 3,
                      style: textStyleRegularBody(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              "Thông báo",
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.CLEAR,
              onTap: () {},
            ),
          ),
          Expanded(
              child: BorderBackground(
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
                      itemBuilder: (c, index) =>
                          _buildItemNotification(context, FAKE_NOTI[index]),
                      separatorBuilder: (c, index) => LineWidget(),
                      itemCount: FAKE_NOTI.length)))
        ],
      ),
    );
  }
}
