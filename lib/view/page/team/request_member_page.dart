import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/team_request.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/item_position.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/viewmodel/request_member_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestMemberPage extends StatelessWidget {
  Widget _buildItemRequest(BuildContext context, TeamRequest teamRequest,
          {Function onAccept, Function onReject}) =>
      BorderItemWidget(
        onTap: () => _showRequestOptions(
          context,
          onAccept: onAccept,
          onReject: onReject,
          onDetail: () => Navigation.instance
              .navigateTo(USER_COMMENT, arguments: teamRequest.userId),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: 'member - ${teamRequest.userId}',
              child: ImageWidget(
                source: teamRequest.avatar,
                placeHolder: Images.DEFAULT_AVATAR,
                boxFit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: UIHelper.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      teamRequest.name ?? teamRequest.username,
                      style: textStyleMediumTitle(),
                    ),
                    Text(
                      'Giới thiệu: ${teamRequest.content}',
                      style: textStyleRegular(),
                    ),
                    Row(
                        children: teamRequest.getPositions
                            .map((pos) => ItemPosition(position: pos))
                            .toList()),
                    Text(
                      'Ngày gửi: ${teamRequest.getCreateDate}',
                      style: textStyleRegularBody(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  _showRequestOptions(BuildContext context,
          {Function onAccept, Function onReject, Function onDetail}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Xem đánh giá',
            'Chấp nhận yêu cầu',
            'Từ chối yêu cầu',
            'Huỷ'
          ],
          onClickOption: (index) {
            if (index == 1) {
              onDetail();
            }
            if (index == 2) {
              onAccept();
            }
            if (index == 3) {
              onReject();
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    Team _team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
            centerContent: Text(
              'Yêu cầu gia nhập đội bóng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<RequestMemberViewModel>(
                  model: RequestMemberViewModel(
                      api: Provider.of(context),
                      teamServices: Provider.of(context)),
                  onModelReady: (model) => model.getTeamRequests(_team.id),
                  builder: (c, model, child) => model.busy
                      ? LoadingWidget()
                      : model.teamRequests.length > 0
                          ? ListView.separated(
                              padding: EdgeInsets.symmetric(
                                  vertical: UIHelper.padding),
                              itemBuilder: (c, index) {
                                TeamRequest _request =
                                    model.teamRequests[index];
                                return _buildItemRequest(
                                  context,
                                  _request,
                                  onAccept: () => model.acceptRequest(
                                      index, _request.idRequest, _team.id),
                                  onReject: () => model.rejectRequest(
                                      index, _request.idRequest),
                                );
                              },
                              separatorBuilder: (c, index) =>
                                  UIHelper.verticalIndicator,
                              itemCount: model.teamRequests.length)
                          : EmptyWidget(message: 'Không có yêu cầu nào')),
            ),
          )
        ],
      ),
    );
  }
}
