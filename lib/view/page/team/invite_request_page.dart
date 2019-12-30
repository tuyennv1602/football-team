import 'package:flutter/material.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/status.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/expandable_text.dart';
import 'package:myfootball/view/widget/customize_image.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/view/widget/customize_tabbar.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/invite_request_viewmodel.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class InviteRequestPage extends StatelessWidget {
  static const TABS = ['Lời mời', 'Đã gửi'];

  _buildItemRequest(BuildContext context, InviteRequest inviteRequest,
          {Function onCancel, Function onAccepted}) =>
      BorderItem(
        onTap: () async {
          if (inviteRequest.status == Constants.INVITE_WAITING &&
              !inviteRequest.isOverTime) {
            Status status = await Navigation.instance
                .navigateTo(INVITE_DETAIL, arguments: inviteRequest);
            if (status != null) {
              if (status == Status.ABORTED) {
                onCancel();
              }
              if (status == Status.DONE) {
                onAccepted();
              }
            }
          } else {
            Navigation.instance.navigateTo(
              TEAM_DETAIL,
              arguments: Team(
                  id: inviteRequest.getId,
                  name: inviteRequest.getName,
                  logo: inviteRequest.getLogo),
            );
          }
        },
        child: Row(
          children: <Widget>[
            CustomizeImage(
              source: inviteRequest.getLogo,
              placeHolder: Images.DEFAULT_LOGO,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: UIHelper.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        inviteRequest.getName,
                        style: textStyleMediumTitle(),
                      ),
                    ),
                    ExpandableText(inviteRequest.title),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          inviteRequest.getCreateTime,
                          style: textStyleRegularBody(color: Colors.grey),
                        ),
                        StatusIndicator(
                          statusName: inviteRequest.getStatusName,
                          status: inviteRequest.getStatus,
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          CustomizeAppBar(
            centerContent: Text(
              'Lời mời ghép đối',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButton(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<InviteRequestViewModel>(
                model: InviteRequestViewModel(
                  api: Provider.of(context),
                ),
                onModelReady: (model) => model.getAllInvites(team.id),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : DefaultTabController(
                        length: 2,
                        child: Column(
                          children: <Widget>[
                            CustomizeTabBar(
                              titles: TABS,
                              height: UIHelper.size45,
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  model.receivedInvites.length == 0
                                      ? EmptyWidget(
                                          message: 'Chưa có lời mời nào')
                                      : ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                              vertical: UIHelper.padding),
                                          itemBuilder: (c, index) =>
                                              _buildItemRequest(
                                                context,
                                                model.receivedInvites[index],
                                                onCancel: () => model
                                                    .removeRequest(0, index),
                                                onAccepted: () =>
                                                    model.acceptRequest(index),
                                              ),
                                          separatorBuilder: (c, index) =>
                                              UIHelper.verticalIndicator,
                                          itemCount:
                                              model.receivedInvites.length),
                                  model.sentInvites.length == 0
                                      ? EmptyWidget(
                                          message: 'Chưa có lời mời nào')
                                      : ListView.separated(
                                          padding: EdgeInsets.symmetric(
                                              vertical: UIHelper.padding),
                                          itemBuilder: (c, index) =>
                                              _buildItemRequest(
                                                context,
                                                model.sentInvites[index],
                                                onCancel: () => model
                                                    .removeRequest(1, index),
                                              ),
                                          separatorBuilder: (c, index) =>
                                              UIHelper.verticalIndicator,
                                          itemCount: model.sentInvites.length),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          UIHelper.homeButtonSpace
        ],
      ),
    );
  }
}
