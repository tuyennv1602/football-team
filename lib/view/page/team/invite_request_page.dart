import 'package:flutter/material.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/status.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/expandable_text_widget.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/view/widget/tabbar_widget.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/invite_request_viewmodel.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class InviteRequestPage extends StatelessWidget {
  static const TABS = ['Lời mời', 'Đã gửi'];

  _buildItemRequest(BuildContext context, InviteRequest inviteRequest,
          {Function onCancel, Function onAccepted}) =>
      BorderItemWidget(
        onTap: () {
          if (inviteRequest.status == Constants.INVITE_WAITING &&
              !inviteRequest.isOverTime) {
            _showOptions(
              context,
              onInviteDetail: () async {
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
              },
              onTeamDetail: () => Navigation.instance.navigateTo(
                TEAM_DETAIL,
                arguments: Team(
                    id: inviteRequest.getId,
                    name: inviteRequest.getName,
                    logo: inviteRequest.getLogo),
              ),
            );
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
            ImageWidget(
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
                    ExpandableTextWidget(inviteRequest.title),
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

  _showOptions(BuildContext context,
          {Function onInviteDetail, Function onTeamDetail}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Chi tiết lời mời',
            'Thông tin đội bóng',
            'Huỷ'
          ],
          onClickOption: (index) {
            if (index == 1) {
              onInviteDetail();
            }
            if (index == 2) {
              onTeamDetail();
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Lời mời ghép đối',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
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
                            TabBarWidget(
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