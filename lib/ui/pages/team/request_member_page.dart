import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/team_request.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/item_position.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/viewmodels/request_member_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestMemberPage extends StatelessWidget {
  Widget _buildItemRequest(BuildContext context, TeamRequest teamRequest,
          {Function onAccept, Function onReject}) =>
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.padding),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
        child: InkWell(
          onTap: () => _showRequestOptions(context,
              onAccept: onAccept, onReject: onReject),
          child: Padding(
            padding: EdgeInsets.all(UIHelper.padding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageWidget(
                    source: teamRequest.avatar,
                    placeHolder: Images.DEFAULT_AVATAR),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: UIHelper.padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          teamRequest.name ?? teamRequest.username,
                          style: textStyleSemiBold(),
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
          ),
        ),
      );

  _showRequestOptions(BuildContext context,
          {Function onAccept, Function onReject}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Chấp nhận yêu cầu', 'Từ chối yêu cầu', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              onAccept();
            }
            if (index == 2) {
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
              onTap: () => NavigationService.instance.goBack(),
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
