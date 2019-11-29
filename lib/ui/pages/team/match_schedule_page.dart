import 'package:flutter/material.dart';
import 'package:myfootball/models/match_schedule.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/clipper_left_widget.dart';
import 'package:myfootball/ui/widgets/clipper_right_widget.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/status_indicator.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/match_schedule_viewmodel.dart';
import 'package:provider/provider.dart';

class MatchSchedulePage extends StatelessWidget {
  _showManagerOptions(BuildContext context, bool hasOpponent, bool isJoined,
          {Function onDetail, Function onRegister}) =>
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
                  'Thông tin trận đấu',
                  isJoined ? 'Huỷ đăng ký thi đấu' : 'Đăng ký thi đấu',
                  'Thêm đối tác',
                  'Huỷ'
                ],
          onClickOption: (index) {
            if (index == 1) {
              onDetail();
            }
            if (index == 2) {
              onRegister(isJoined);
            }
            if (index == 3) {
              handleUpdateOpponentTeam(context);
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

  handleUpdateOpponentTeam(BuildContext context) async {
//    var result = await Routes.routeToSearchTeam(
//        context, SEARCH_TYPE.SELECT_OPPONENT_TEAM);
//    print(result.name);
  }

  Widget _buildItemSchedule(BuildContext context, bool isCaptain, int index,
      MatchScheduleViewModel model) {
    MatchSchedule matchSchedule = model.matchSchedules[index];
    var _hasReceiveTeam = matchSchedule.receiveTeam != null;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.padding),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
      child: InkWell(
        onTap: () {
          if (isCaptain) {
            _showManagerOptions(
              context,
              matchSchedule.receiveTeam != null,
              matchSchedule.isJoined,
              onDetail: () => NavigationService.instance
                  .navigateTo(MATCH_DETAIL, arguments: matchSchedule),
              onRegister: (isJoined) => !isJoined
                  ? model.joinMatch(index, matchSchedule.matchId)
                  : UIHelper.showConfirmDialog(
                      'Bạn có chắc muốn huỷ tham gia trận đấu này?',
                      onConfirmed: () =>
                          model.leaveMatch(index, matchSchedule.matchId),
                    ),
            );
          } else {
            _showMemberOptions(
              context,
              matchSchedule.isJoined,
              onDetail: () => NavigationService.instance
                  .navigateTo(MATCH_DETAIL, arguments: matchSchedule),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            UIHelper.verticalSpaceSmall,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: UIHelper.size15),
                            child: Text(
                              matchSchedule.getMyTeamName + '\n',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: textStyleMedium(),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: UIHelper.size10),
                          child: ImageWidget(
                            source: matchSchedule.getMyTeamLogo,
                            placeHolder: Images.DEFAULT_LOGO,
                            size: UIHelper.size30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'VS',
                    textAlign: TextAlign.center,
                    style: textStyleSemiBold(color: Colors.red),
                  ),
                  Expanded(
                    child: _hasReceiveTeam
                        ? Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: UIHelper.size10),
                                child: ImageWidget(
                                  source: matchSchedule.getOpponentLogo,
                                  placeHolder: Images.DEFAULT_LOGO,
                                  size: UIHelper.size30,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: UIHelper.size15),
                                  child: Text(
                                    matchSchedule.getOpponentName + '\n',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: textStyleMedium(),
                                  ),
                                ),
                              )
                            ],
                          )
                        : SizedBox(),
                  ),
                ],
              ),
            ),
            UIHelper.verticalSpaceMedium,
            LineWidget(indent: 0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: UIHelper.size10, right: UIHelper.size5),
                    child: Text(
                      matchSchedule.groundName,
                      style: textStyleRegular(color: GREEN_TEXT),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(UIHelper.padding),
                      topLeft: Radius.circular(UIHelper.size50)),
                  child: ClipPath(
                    clipper: ClipperRightWidget(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF02DC37), PRIMARY],
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: UIHelper.size5,
                          horizontal: UIHelper.size15),
                      child: Text(
                        matchSchedule.getShortPlayTime,
                        style: textStyleSemiBold(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _team = Provider.of<Team>(context);
    var isCaptain = Provider.of<User>(context).id == _team.manager;
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
                model: MatchScheduleViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getMatchSchedules(_team.id),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.matchSchedules.length == 0
                        ? EmptyWidget(message: 'Chưa có lịch thi đấu')
                        : ListView.separated(
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
        ],
      ),
    );
  }
}
