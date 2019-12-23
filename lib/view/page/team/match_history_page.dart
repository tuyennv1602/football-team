import 'package:flutter/material.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
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
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/input_score_widget.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/refresh_loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/match_history_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base_widget.dart';

class MatchHistoryPage extends StatelessWidget {
  final RefreshController _matchController = RefreshController();

  _showSenderOptions(BuildContext context,
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

  _showReceiveOptions(BuildContext context,
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

  _showUpdateScore(BuildContext context, MatchHistory matchHistory,
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: UIHelper.size10),
                        child: Text(
                          matchHistory.getMyTeamName,
                          style: textStyleAlert(),
                        ),
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
          Padding(
            padding: EdgeInsets.only(top: UIHelper.size20),
            child: Row(
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
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: UIHelper.size10),
                          child: Text(
                            matchHistory.getOpponentName,
                            style: textStyleAlert(),
                          ),
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
          ),
        ],
      ),
      onConfirmed: () => matchHistory.isSender
          ? onSubmit(firstScore, secondScore)
          : onSubmit(secondScore, firstScore),
    );
  }

  _buildItemHistory(BuildContext context, int index, MatchHistory matchHistory,
      {Function onSubmit, Function onConfirm}) {
    bool isCaptain =
        Provider.of<Team>(context).managerId == Provider.of<User>(context).id;
    return BorderItemWidget(
      onTap: () {
        if (isCaptain &&
            !matchHistory.isConfirmed &&
            matchHistory.isAbleConfirm &&
            matchHistory.hasOpponentTeam) {
          if (matchHistory.isSender) {
            _showSenderOptions(context,
                onUpdateScore: () => _showUpdateScore(
                      context,
                      matchHistory,
                      onSubmit: (firstScore, secondScore) =>
                          onSubmit(firstScore, secondScore),
                    ),
                onDetail: () => Navigation.instance
                    .navigateTo(MATCH_HISTORY_DETAIL, arguments: matchHistory));
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
                      onConfirmed: () => onConfirm());
                }
              },
              onDetail: () => Navigation.instance
                  .navigateTo(MATCH_HISTORY_DETAIL, arguments: matchHistory),
            );
          }
        } else {
          Navigation.instance
              .navigateTo(MATCH_HISTORY_DETAIL, arguments: matchHistory);
        }
      },
      padding: EdgeInsets.symmetric(
          vertical: UIHelper.padding, horizontal: UIHelper.size10),
      child: Column(
        children: <Widget>[
          Container(
            height: UIHelper.size35,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: UIHelper.size10),
                  child: ImageWidget(
                    source: matchHistory.getMyTeamLogo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size35,
                  ),
                ),
                Expanded(
                  child: Text(
                    matchHistory.getMyTeamName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleMediumTitle(),
                  ),
                ),
                Text(
                  matchHistory.getMyTeamScore,
                  style: textStyleBold(
                      size: 20,
                      color: matchHistory.isConfirmed
                          ? Colors.black
                          : Colors.grey),
                )
              ],
            ),
          ),
          matchHistory.hasOpponentTeam
              ? Container(
                  height: UIHelper.size20,
                  padding: EdgeInsets.only(left: UIHelper.size45),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'VS',
                        style: textStyleMedium(size: 12, color: Colors.grey),
                      ),
                      Expanded(child: LineWidget())
                    ],
                  ),
                )
              : SizedBox(),
          Container(
            height: matchHistory.hasOpponentTeam ? UIHelper.size35 : 0,
            child: matchHistory.hasOpponentTeam
                ? Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: UIHelper.size10),
                        child: ImageWidget(
                          source: matchHistory.getOpponentLogo,
                          placeHolder: Images.DEFAULT_LOGO,
                          size: UIHelper.size35,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          matchHistory.getOpponentName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyleMediumTitle(),
                        ),
                      ),
                      Text(
                        matchHistory.getOpponentTeamScore,
                        style: textStyleBold(
                            size: 20,
                            color: matchHistory.isConfirmed
                                ? Colors.black
                                : Colors.grey),
                      )
                    ],
                  )
                : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIHelper.padding),
            child: LineWidget(indent: 0),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Row(
                children: <Widget>[
                  matchHistory.getMyTeamPoint != null
                      ? Text(
                          matchHistory.getMyTeamPoint.toStringAsFixed(2),
                          style: textStyleMedium(
                              size: 14,
                              color: matchHistory.getMyTeamPoint > 0
                                  ? GREEN_TEXT
                                  : Colors.red),
                        )
                      : SizedBox(),
                  matchHistory.getMyTeamPoint != null
                      ? Padding(
                          padding: EdgeInsets.only(left: 2),
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
                  matchHistory.countConfirmed > 0
                      ? Text(
                          ' +${matchHistory.getBonus}',
                          style: textStyleMedium(
                              size: 14, color: matchHistory.getRateColor),
                        )
                      : SizedBox(),
                ],
              )),
              StatusIndicator(
                statusName: matchHistory.getStatusName,
                status: matchHistory.getStatus,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _handleSubmit(int index, String firstScore, String secondScore,
      MatchHistoryViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.updateScore(index, firstScore, secondScore);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
          'Đã gửi yêu cầu xác nhận tỉ số tới đối tác. Vui lòng chờ đối tác xác nhận!',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  _handleConfirm(int index, MatchHistoryViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.confirmScore(index);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
          'Cảm ơn bạn vì đã xác nhận. Các cầu thủ có thể tham gia xác nhận tỉ số để tăng độ tín nhiệm của kết quả và nhận điểm thưởng',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
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
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MatchHistoryViewModel>(
                model: MatchHistoryViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getHistories(_team.id, 1, false),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.matchHistories.length == 0
                        ? EmptyWidget(message: 'Chưa có lịch sử thi đấu')
                        : SmartRefresher(
                            controller: _matchController,
                            enablePullDown: true,
                            header: RefreshLoading(),
                            onRefresh: () async {
                              await model.getHistories(_team.id, 1, true);
                              _matchController.refreshCompleted();
                            },
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.padding),
                                itemBuilder: (c, index) => _buildItemHistory(
                                      context,
                                      index,
                                      model.matchHistories[index],
                                      onSubmit: (firstScore, secondScore) =>
                                          _handleSubmit(index, firstScore,
                                              secondScore, model),
                                      onConfirm: () =>
                                          _handleConfirm(index, model),
                                    ),
                                separatorBuilder: (c, index) =>
                                    UIHelper.verticalIndicator,
                                itemCount: model.matchHistories.length),
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