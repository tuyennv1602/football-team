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
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
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
    return InkWell(
      onTap: () {
        if (isCaptain) {
          _showManagerOptions(
            context,
            matchSchedule.receiveTeam != null,
            matchSchedule.isJoined,
            onDetail: () => NavigationService.instance()
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
            onDetail: () => NavigationService.instance()
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
        children: <Widget>[
          UIHelper.verticalSpaceSmall,
          Container(
            height: UIHelper.size(80),
            padding: EdgeInsets.all(UIHelper.size5),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: UIHelper.size25,
                  left: UIHelper.size35,
                  right: UIHelper.size35,
                  child: Container(
                    height: UIHelper.size40,
                    padding: EdgeInsets.symmetric(horizontal: UIHelper.size20),
                    color: SHADOW_GREEN,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            matchSchedule.getMyTeamName,
                            style: textStyleSemiBold(size: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          height: UIHelper.size20,
                          width: UIHelper.size20,
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(UIHelper.size5),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.circular(UIHelper.size10)),
                          child: Text(
                            'VS',
                            style: textStyleSemiBold(
                                color: Colors.white, size: 10),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _hasReceiveTeam
                                ? matchSchedule.getOpponentName
                                : '',
                            textAlign: TextAlign.right,
                            style: textStyleSemiBold(size: 13),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                    child: Container(
                      height: UIHelper.size25,
                      width: UIHelper.size(120),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(UIHelper.size15),
                          topLeft: Radius.circular(UIHelper.size15),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: UIHelper.size10),
                      child: Text(
                        matchSchedule.getShortPlayTime,
                        style: textStyleSemiBold(color: Colors.white, size: 15),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: UIHelper.size20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: UIHelper.size50,
                        width: UIHelper.size50,
                        padding: EdgeInsets.all(UIHelper.size5),
                        decoration: BoxDecoration(
                            color: SHADOW_GREEN,
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(UIHelper.size25)),
                        child: ImageWidget(
                          source: matchSchedule.getMyTeamLogo,
                          placeHolder: Images.DEFAULT_LOGO,
                          size: UIHelper.size40,
                          radius: UIHelper.size20,
                        ),
                      ),
                      Container(
                        height: UIHelper.size50,
                        width: UIHelper.size50,
                        padding: EdgeInsets.all(UIHelper.size5),
                        decoration: BoxDecoration(
                            color: SHADOW_GREEN,
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(UIHelper.size25)),
                        child: _hasReceiveTeam
                            ? ImageWidget(
                                source: matchSchedule.getOpponentLogo,
                                placeHolder: Images.DEFAULT_LOGO,
                                size: UIHelper.size40,
                                radius: UIHelper.size20,
                              )
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            matchSchedule.groundName,
            style: textStyleRegular(),
          ),
          UIHelper.verticalSpaceLarge
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
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
              onTap: () => NavigationService.instance().goBack(),
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
                            padding:
                                EdgeInsets.symmetric(vertical: UIHelper.size10),
                            itemBuilder: (c, index) => _buildItemSchedule(
                                context, isCaptain, index, model),
                            separatorBuilder: (c, index) => LineWidget(),
                            itemCount: model.matchSchedules.length),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
