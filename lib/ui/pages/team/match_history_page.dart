import 'package:flutter/material.dart';
import 'package:myfootball/models/match_history.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/input_score_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/status_indicator.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/match_history_viewmodel.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class MatchHistoryPage extends StatelessWidget {
  void _showSenderOptions(BuildContext context,
          {Function onUpdateScore, Function onDetail}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Cập nhật tỉ số', 'Thông tin trận đấu', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              onUpdateScore();
            }
            if (index == 2) {
              onDetail();
            }
          },
        ),
      );

  void _showReceiveOptions(BuildContext context,
          {Function onConfirmScore, Function onDetail}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Xác nhận tỉ số', 'Thông tin trận đấu', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              onConfirmScore();
            }
            if (index == 2) {
              onDetail();
            }
          },
        ),
      );

  void _showUpdateScore(BuildContext context, MatchHistory matchHistory,
      {Function onSubmit}) {
    String firstScore;
    String secondScore;
    return UIHelper.showConfirmDialog(
      'update_score',
      icon: Images.EDIT_PROFILE,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    ImageWidget(
                      source: matchHistory.getMyTeamLogo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size35,
                    ),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(
                      child: Text(
                        matchHistory.getMyTeamName,
                        style: textStyleAlert(),
                      ),
                    )
                  ],
                ),
              ),
              InputScoreWidget(
                onChangedText: (text) => firstScore = text,
              )
            ],
          ),
          UIHelper.verticalSpaceLarge,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    ImageWidget(
                      source: matchHistory.getOpponentLogo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size35,
                    ),
                    UIHelper.horizontalSpaceMedium,
                    Expanded(
                      child: Text(
                        matchHistory.getOpponentName,
                        style: textStyleAlert(),
                      ),
                    )
                  ],
                ),
              ),
              InputScoreWidget(
                onChangedText: (text) => secondScore = text,
              )
            ],
          ),
        ],
      ),
      onConfirmed: () => matchHistory.isSender
          ? onSubmit(firstScore, secondScore)
          : onSubmit(secondScore, firstScore),
    );
  }

  Widget _buildItemHistory(
      BuildContext context, int index, MatchHistory matchHistory,
      {Function onSubmit, Function onConfirm}) {
    bool isCaptain =
        Provider.of<Team>(context).manager == Provider.of<User>(context).id;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.padding),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
      child: InkWell(
        onTap: () {
          if (isCaptain && !matchHistory.isConfirmed) {
            if (matchHistory.isSender) {
              _showSenderOptions(context,
                  onUpdateScore: () => _showUpdateScore(
                        context,
                        matchHistory,
                        onSubmit: (firstScore, secondScore) =>
                            onSubmit(matchHistory.id, firstScore, secondScore),
                      ),
                  onDetail: () => NavigationService.instance
                      .navigateTo(MATCH_DETAIL, arguments: matchHistory));
            } else {
              _showReceiveOptions(
                context,
                onConfirmScore: () {
                  if (!matchHistory.isUpdated) {
                    UIHelper.showSimpleDialog(
                        'Đối tác chưa cập nhật tỉ số. Vui lòng chờ đối tác cập nhật tỉ số!');
                  } else {
                    UIHelper.showConfirmDialog(
                        'Bạn có chắc chắn tỉ số mà ${matchHistory.getOpponentName} đã cập nhật cho trận đấu này là chính xác?',
                        onConfirmed: () => onConfirm(matchHistory.id));
                  }
                },
                onDetail: () => NavigationService.instance
                    .navigateTo(MATCH_DETAIL, arguments: matchHistory),
              );
            }
          } else {
            NavigationService.instance
                .navigateTo(MATCH_DETAIL, arguments: matchHistory);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: UIHelper.padding, horizontal: UIHelper.size10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: UIHelper.size15),
                            child: Text(
                              matchHistory.getMyTeamName + '\n',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: textStyleMedium(),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: UIHelper.size5),
                          child: ImageWidget(
                            source: matchHistory.getMyTeamLogo,
                            placeHolder: Images.DEFAULT_LOGO,
                            size: UIHelper.size30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: UIHelper.size(60),
                    child: Text(
                      '${matchHistory.getMyTeamScore}-${matchHistory.getOpponentTeamScore}',
                      textAlign: TextAlign.center,
                      style: textStyleBold(
                          color: matchHistory.isConfirmed
                              ? Colors.red
                              : Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: UIHelper.size5),
                          child: ImageWidget(
                            source: matchHistory.getOpponentLogo,
                            placeHolder: Images.DEFAULT_LOGO,
                            size: UIHelper.size30,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: UIHelper.size15),
                            child: Text(
                              matchHistory.getOpponentName + '\n',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: textStyleMedium(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpaceMedium,
              LineWidget(),
              UIHelper.verticalSpaceMedium,
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: UIHelper.size10),
                      child: StatusIndicator(
                        isActive: matchHistory.isConfirmed,
                        status: matchHistory.getStatus,
                      ),
                    ),
                  ),
                  matchHistory.isConfirmed
                      ? Text(
                          matchHistory.getMyTeamPoint.toStringAsFixed(2),
                          style: textStyleSemiBold(
                              size: 14,
                              color: matchHistory.getMyTeamPoint > 0
                                  ? GREEN_TEXT
                                  : Colors.red),
                        )
                      : SizedBox(),
                  matchHistory.isConfirmed
                      ? Padding(
                          padding:
                              EdgeInsets.only(right: UIHelper.size10, left: 2),
                          child: Image.asset(
                            matchHistory.getMyTeamPoint > 0
                                ? Images.UP
                                : Images.DOWN,
                            width: UIHelper.size(12),
                            height: UIHelper.size(12),
                            color: matchHistory.getMyTeamPoint > 0
                                ? GREEN_TEXT
                                : Colors.red,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              matchHistory.isConfirmed ?
              Padding(
                padding: EdgeInsets.only(left: UIHelper.size10, right: UIHelper.size10, top: UIHelper.size10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Điểm thưởng',
                      style: textStyleRegularBody(color: Colors.grey),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: UIHelper.size10),
                        child: LinearPercentIndicator(
                          animation: true,
                          lineHeight: UIHelper.size(6),
                          animationDuration: 1000,
                          percent: matchHistory.getRatePercent,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: matchHistory.getRateColor,
                          backgroundColor: LINE_COLOR,
                        ),
                      ),
                    ),
                    Text(
                      '+${matchHistory.getBonus.toStringAsFixed(2)}',
                      style: textStyleSemiBold(
                          size: 14, color: matchHistory.getRateColor),
                    )
                  ],
                ),
              ) : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Lịch sử thi đấu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: AppBarButtonWidget(
              imageName: Images.INFO,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MatchHistoryViewModel>(
                model: MatchHistoryViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getHistories(_team.id, 1),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.matchHistories.length == 0
                        ? EmptyWidget(message: 'Chưa có lịch sử thi đấu')
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                vertical: UIHelper.padding),
                            itemBuilder: (c, index) => _buildItemHistory(
                                  context,
                                  index,
                                  model.matchHistories[index],
                                  onSubmit:
                                      (historyId, firstScore, secondScore) =>
                                          model.updateScore(index, historyId,
                                              firstScore, secondScore),
                                  onConfirm: (historyId) =>
                                      model.confirmScore(index, historyId),
                                ),
                            separatorBuilder: (c, index) =>
                                UIHelper.verticalIndicator,
                            itemCount: model.matchHistories.length),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
