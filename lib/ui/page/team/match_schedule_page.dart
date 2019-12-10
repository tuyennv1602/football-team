import 'package:flutter/material.dart';
import 'package:myfootball/model/invite_request.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/page/team/search_team_page.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/bottom_sheet.dart';
import 'package:myfootball/ui/widget/choose_ratio_widget.dart';
import 'package:myfootball/ui/widget/clipper_right_widget.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/input_text_widget.dart';
import 'package:myfootball/ui/widget/item_match_schedule.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/refresh_loading.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/match_schedule_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class MatchSchedulePage extends StatelessWidget {
  final _formInvite = GlobalKey<FormState>();
  Team team;
  final RefreshController _matchController = RefreshController();

  bool validateAndSave() {
    final form = _formInvite.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _showManagerOptions(BuildContext context, bool hasOpponent, bool isJoined,
          {Function onDetail, Function onRegister, Function onInvite}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: hasOpponent
              ? [
                  'Tuỳ chọn',
                  'Thông tin trận đấu',
                  isJoined ? 'Huỷ đăng ký thi đấu' : 'Đăng ký thi đấu',
                  'Huỷ'
                ]
              : [
                  'Tuỳ chọn',
                  'Mời đối tác',
                  'Thông tin trận đấu',
                  isJoined ? 'Huỷ đăng ký thi đấu' : 'Đăng ký thi đấu',
                  'Huỷ'
                ],
          onClickOption: (index) {
            if (hasOpponent) {
              if (index == 1) {
                onDetail();
              }
              if (index == 2) {
                onRegister(isJoined);
              }
            } else {
              if (index == 1) {
                onInvite();
              }
              if (index == 2) {
                onDetail();
              }
              if (index == 3) {
                onRegister(isJoined);
              }
            }
          },
        ),
      );

  _showMemberOptions(BuildContext context, bool isJoined,
          {Function onDetail, Function onRegister}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Thông tin trận đấu',
            isJoined ? 'Huỷ đăng ký thi đấu' : 'Đăng ký thi đấu',
            'Huỷ'
          ],
          onClickOption: (index) {
            if (index == 1) {
              onDetail();
            }
            if (index == 2) {
              onRegister(isJoined);
            }
          },
        ),
      );

  handleUpdateOpponentTeam(BuildContext context, int matchId,
      {Function onSubmit}) async {
    var result = await NavigationService.instance.navigateTo(SEARCH_TEAM,
        arguments: SEARCH_TYPE.SELECT_OPPONENT_TEAM) as Team;
    var _invite;
    var _ratio;
    UIHelper.showCustomizeDialog(
      'input_invite',
      icon: Images.INVITE,
      child: Column(
        children: <Widget>[
          Form(
            key: _formInvite,
            child: InputTextWidget(
              validator: (value) {
                if (value.isEmpty) return 'Vui lòng nhập lời mời';
                return null;
              },
              onSaved: (value) => _invite = value,
              maxLines: 2,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              labelText: 'Lời mời',
              focusedColor: Colors.white,
              textStyle: textStyleInput(color: Colors.white),
              hintTextStyle: textStyleInput(color: Colors.white),
            ),
          ),
          ChooseRatioTypeWidget(
            onSelectedType: (type) => _ratio = type,
            primaryColor: Colors.white,
          ),
        ],
      ),
      onConfirmed: () {
        if (validateAndSave()) {
          NavigationService.instance.goBack();
          onSubmit(
            InviteRequest(
                matchId: matchId,
                title: _invite,
                sendGroupId: team.id,
                sendGroupLogo: team.logo,
                sendGroupName: team.name,
                ratio: _ratio,
                receiveGroupId: result.id),
          );
        }
      },
    );
  }

  Widget _buildItemSchedule(BuildContext context, bool isCaptain, int index,
      MatchScheduleViewModel model) {
    MatchSchedule matchSchedule = model.matchSchedules[index];
    return ItemMatchSchedule(
      matchSchedule: matchSchedule,
      onTapSchedule: () {
        if (isCaptain) {
          _showManagerOptions(
            context,
            matchSchedule.receiveTeam != null,
            matchSchedule.isJoined,
            onDetail: () => NavigationService.instance
                .navigateTo(MATCH_SCHEDULE_DETAIL, arguments: matchSchedule),
            onRegister: (isJoined) => !isJoined
                ? model.joinMatch(index, matchSchedule.matchId)
                : UIHelper.showConfirmDialog(
                    'Bạn có chắc muốn huỷ tham gia trận đấu này?',
                    onConfirmed: () =>
                        model.leaveMatch(index, matchSchedule.matchId),
                  ),
            onInvite: () => handleUpdateOpponentTeam(
              context,
              matchSchedule.matchId,
              onSubmit: (request) => model.sendInvite(request),
            ),
          );
        } else {
          _showMemberOptions(
            context,
            matchSchedule.isJoined,
            onDetail: () => NavigationService.instance
                .navigateTo(MATCH_SCHEDULE_DETAIL, arguments: matchSchedule),
            onRegister: (isJoined) => !isJoined
                ? model.joinMatch(index, matchSchedule.matchId)
                : UIHelper.showConfirmDialog(
                    'Bạn có chắc muốn huỷ tham gia trận đấu này?',
                    onConfirmed: () =>
                        model.leaveMatch(index, matchSchedule.matchId),
                  ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    team = Provider.of<Team>(context);
    var isCaptain = Provider.of<User>(context).id == team.managerId;
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Lịch thi đấu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MatchScheduleViewModel>(
                model: MatchScheduleViewModel(
                    api: Provider.of(context), teamId: team.id),
                onModelReady: (model) => model.getMatchSchedules(1, false),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.matchSchedules.length == 0
                        ? EmptyWidget(message: 'Chưa có lịch thi đấu')
                        : SmartRefresher(
                            controller: _matchController,
                            enablePullDown: true,
                            header: RefreshLoading(),
                            onRefresh: () async {
                              await model.getMatchSchedules(1, true);
                              _matchController.refreshCompleted();
                            },
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.padding),
                                itemBuilder: (c, index) => _buildItemSchedule(
                                    context, isCaptain, index, model),
                                separatorBuilder: (c, index) =>
                                    UIHelper.verticalIndicator,
                                itemCount: model.matchSchedules.length),
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
