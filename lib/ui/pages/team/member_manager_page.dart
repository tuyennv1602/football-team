import 'package:flutter/material.dart';
import 'package:myfootball/models/member.dart';
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
import 'package:myfootball/ui/widgets/item_member.dart';
import 'package:myfootball/ui/widgets/item_position.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/tabbar_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/viewmodels/member_manager_viewmodel.dart';
import 'package:provider/provider.dart';

class MemberManagerPage extends StatelessWidget {
  static const TABS = ['Thành viên', 'Yêu cầu'];

  Widget _buildItemRequest(BuildContext context, TeamRequest teamRequest,
          Function onAccept, Function onDeny) =>
      Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.size15),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
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
      MemberMangerViewModel model, int index, int idRequest, int teamId) async {
    UIHelper.showProgressDialog;
    var resp = await model.acceptRequest(index, idRequest, teamId);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  void _handleRejectRequest(
      MemberMangerViewModel model, int index, int idRequest) async {
    UIHelper.showProgressDialog;
    var resp = await model.rejectRequest(index, idRequest);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  Widget _buildTeamRequests(BuildContext context,
      List<TeamRequest> teamRequests, Function onApproved, Function onReject) {
    return teamRequests.length > 0
        ? ListView.separated(
            padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
            itemBuilder: (c, index) {
              TeamRequest _request = teamRequests[index];
              return _buildItemRequest(
                  context,
                  teamRequests[index],
                  () => onApproved(index, _request.idRequest),
                  () => onReject(index, _request.idRequest));
            },
            separatorBuilder: (c, index) => SizedBox(height: UIHelper.size10),
            itemCount: teamRequests.length)
        : EmptyWidget(message: 'Không có yêu cầu nào');
  }

  Widget _buildTeamMembers(
          BuildContext context, int managerId, List<Member> members) =>
      ListView.separated(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
          itemBuilder: (c, index) {
            Member _member = members[index];
            return ItemMember(
              member: _member,
              isCaptain: _member.id == managerId,
              onTap: () => _showMemberOptions(context, _member),
            );
          },
          separatorBuilder: (c, index) => LineWidget(),
          itemCount: members.length);

  void _showClearPoints(BuildContext context) => showModalBottomSheet(
      context: context,
      builder: (c) => BottomSheetWidget(
            options: ['Tuỳ chọn', 'Reset điểm thành viên', 'Huỷ'],
          ));

  void _showRequestOptions(BuildContext context, Function onSelected) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Chấp nhận', 'Từ chối', 'Huỷ'],
          onClickOption: (index) => onSelected(index),
        ),
      );

  void _showMemberOptions(BuildContext context, Member member) =>
      showModalBottomSheet(
          context: context,
          builder: (c) => BottomSheetWidget(
                options: [
                  'Tuỳ chọn',
                  'Xem chi tiết',
                  'Đánh giá',
                  'Xoá khỏi đội',
                  'Huỷ'
                ],
              ));

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
            rightContent: AppBarButtonWidget(
              imageName: Images.MORE,
              onTap: () => _showClearPoints(context),
            ),
            centerContent: Text(
              'Quản lý thành viên',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: DefaultTabController(
                length: TABS.length,
                child: BaseWidget<MemberMangerViewModel>(
                  model: MemberMangerViewModel(
                      api: Provider.of(context),
                      teamServices: Provider.of(context)),
                  onModelReady: (model) => model.getTeamRequests(_team.id),
                  child: TabBarWidget(
                    titles: TABS,
                  ),
                  builder: (c, model, child) => Column(
                    children: <Widget>[
                      child,
                      Expanded(
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            _buildTeamMembers(context, _team.manager, _team.members),
                            _buildTeamRequests(
                                context,
                                model.teamRequests,
                                (index, id) => _handleApprovedRequest(
                                    model, index, id, _team.id),
                                (index, id) =>
                                    _handleRejectRequest(model, index, id)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
