import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/team_request.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet_widget.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/item_position.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/viewmodels/request_member_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestMemberPage extends StatelessWidget {
  Widget _buildItemRequest(BuildContext context, TeamRequest teamRequest,
          Function onAccept, Function onDeny) =>
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.size15),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.size15),
        child: InkWell(
          onTap: () => _showRequestOptions(context, (index) {
            if (index == 1) {
              onAccept();
            }
            if (index == 2) {
              onDeny();
            }
          }),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: UIHelper.size15, vertical: UIHelper.size10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageWidget(
                    source: teamRequest.avatar,
                    placeHolder: Images.DEFAULT_AVATAR),
                UIHelper.horizontalSpaceMedium,
                Expanded(
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
                        'Ngày tạo: ${teamRequest.getCreateDate}',
                        style: textStyleRegularBody(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _handleApprovedRequest(
      RequestMemberViewModel model, int index, int idRequest, int teamId) async {
    UIHelper.showProgressDialog;
    var resp = await model.acceptRequest(index, idRequest, teamId);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  void _handleRejectRequest(
      RequestMemberViewModel model, int index, int idRequest) async {
    UIHelper.showProgressDialog;
    var resp = await model.rejectRequest(index, idRequest);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  void _showRequestOptions(BuildContext context, Function onSelected) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Chấp nhận', 'Từ chối', 'Huỷ'],
          onClickOption: (index) => onSelected(index),
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    Team _team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
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
                  builder: (c, model, child) => model.teamRequests.length > 0
                      ? ListView.separated(
                          padding:
                              EdgeInsets.symmetric(vertical: UIHelper.size15),
                          itemBuilder: (c, index) {
                            TeamRequest _request = model.teamRequests[index];
                            return _buildItemRequest(
                              context,
                              _request,
                              () => _handleApprovedRequest(
                                  model, index, _request.idRequest, _team.id),
                              () => _handleRejectRequest(
                                  model, index, _request.idRequest),
                            );
                          },
                          separatorBuilder: (c, index) => UIHelper.verticalIndicator,
                          itemCount: model.teamRequests.length)
                      : EmptyWidget(message: 'Không có yêu cầu nào')),
            ),
          )
        ],
      ),
    );
  }
}
