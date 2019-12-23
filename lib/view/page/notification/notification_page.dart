import 'package:myfootball/model/notification.dart' as noti;
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:flutter/material.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/expandable_text_widget.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/refresh_loading.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/notification_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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

  RefreshController _notifyController = RefreshController();

   _buildItemNotification(
          BuildContext context, noti.Notification notification) =>
      BorderItemWidget(
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
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: ExpandableTextWidget(notification.body,
                  textStyle: textStyleRegularBody()),
            ),
          ],
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
                onModelReady: (model) => model.getNotifications(false),
                builder: (c, model, child) {
                  if (model.busy) {
                    return LoadingWidget();
                  }
                  return model.notifications.length > 0
                      ? SmartRefresher(
                          enablePullDown: true,
                          controller: _notifyController,
                          header: RefreshLoading(),
                          onRefresh: () async{
                            await model.getNotifications(true);
                            _notifyController.refreshCompleted();
                          },
                          child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  vertical: UIHelper.padding),
                              itemBuilder: (c, index) => _buildItemNotification(
                                  context, model.notifications[index]),
                              separatorBuilder: (c, index) =>
                                  UIHelper.verticalIndicator,
                              itemCount: model.notifications.length),
                        )
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
