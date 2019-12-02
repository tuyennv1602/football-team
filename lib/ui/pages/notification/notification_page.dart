import 'package:myfootball/models/notification.dart' as noti;
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/expandable_text_widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/notification_viewmodel.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificationState();
  }
}

class NotificationState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _buildItemNotification(
          BuildContext context, noti.Notification notification) =>
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.padding),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
        child: Padding(
          padding: EdgeInsets.all(UIHelper.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: notification.title,
                      style: textStyleMediumTitle(),
                    ),
                    TextSpan(
                      text: ' - ${notification.getCreateTime}',
                      style: textStyleRegularBody(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              UIHelper.verticalSpaceSmall,
              ExpandableTextWidget(notification.body,
                  textStyle: textStyleRegular()),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              child: BaseWidget<NotificationViewModel>(
                model: NotificationViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getNotifications(),
                builder: (c, model, child) {
                  if (model.busy) {
                    return LoadingWidget();
                  }
                  return model.notifications.length > 0
                      ? ListView.separated(
                          physics: BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.symmetric(vertical: UIHelper.padding),
                          itemBuilder: (c, index) => _buildItemNotification(
                              context, model.notifications[index]),
                          separatorBuilder: (c, index) =>
                              UIHelper.verticalIndicator,
                          itemCount: model.notifications.length)
                      : EmptyWidget(message: 'Không có thông báo nào');
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
