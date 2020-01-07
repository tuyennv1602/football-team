import 'package:flutter/material.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/customize_image.dart';
import 'package:myfootball/view/widget/input_score.dart';
import 'package:myfootball/view/widget/item_match_history.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/loadmore_loading.dart';
import 'package:myfootball/view/widget/refresh_loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/match_history_vm.dart';
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
                    CustomizeImage(
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
              InputScore(
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
                      CustomizeImage(
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
                InputScore(
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
      bool isCaptain,
      {Function onSubmit, Function onConfirm}) {
    return ItemMatchHistory(
      matchHistory: matchHistory,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var _team = Provider.of<Team>(context);
    var _userId = Provider.of<User>(context).id;
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          CustomizeAppBar(
            centerContent: Text(
              'Lịch sử thi đấu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButton(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: AppBarButton(
              imageName: Images.INFO,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MatchHistoryViewModel>(
                model: MatchHistoryViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getHistories(_team.id, false),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.matchHistories.length == 0
                        ? EmptyWidget(message: 'Chưa có lịch sử thi đấu')
                        : SmartRefresher(
                            controller: _matchController,
                            enablePullDown: true,
                            enablePullUp: model.canLoadMore,
                            footer: LoadMoreLoading(),
                            header: RefreshLoading(),
                            onRefresh: () async {
                              await model.getHistories(_team.id, true);
                              _matchController.refreshCompleted();
                            },
                            onLoading: () async {
                              await model.getHistories(_team.id, false);
                              _matchController.loadComplete();
                            },
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.padding),
                                itemBuilder: (c, index) => _buildItemHistory(
                                      context,
                                      index,
                                      model.matchHistories[index],
                                      _team.hasManager(_userId),
                                      onSubmit: (historyId, firstScore,
                                              secondScore) =>
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
          ),
          UIHelper.homeButtonSpace
        ],
      ),
    );
  }
}
