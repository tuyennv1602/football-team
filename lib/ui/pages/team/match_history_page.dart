import 'package:flutter/material.dart';
import 'package:myfootball/models/match_history.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/input_score_widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/match_history_viewmodel.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class MatchHistoryPage extends StatelessWidget {
  void _showSenderOptions(BuildContext context, {Function onUpdateScore}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Cập nhật tỉ số', 'Thông tin trận đấu', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              onUpdateScore();
            }
          },
        ),
      );

  void _showReceiveOptions(BuildContext context, {Function onConfirmScore}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Xác nhận tỉ số', 'Thông tin trận đấu', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              onConfirmScore();
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
      {Function onSubmit}) {
    bool isCaptain =
        Provider.of<Team>(context).manager == Provider.of<User>(context).id;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.size10),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
      child: InkWell(
        onTap: () {
          if (isCaptain && !matchHistory.isConfirmed) {
            if (matchHistory.isSender) {
              _showSenderOptions(
                context,
                onUpdateScore: () => _showUpdateScore(
                  context,
                  matchHistory,
                  onSubmit: (firstScore, secondScore) =>
                      onSubmit(matchHistory.id, firstScore, secondScore),
                ),
              );
            } else {
              _showReceiveOptions(
                context,
                onConfirmScore: () {
                  if (!matchHistory.isUpdated) {
                    UIHelper.showSimpleDialog(
                        'Đối tác chưa cập nhật tỉ số. Vui lòng chờ đối tác cập nhật tỉ số!');
                  }
                },
              );
            }
          } else {
            // xem chi tiet tran dau
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: UIHelper.size15, horizontal: UIHelper.size5),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    ImageWidget(
                      source: matchHistory.getMyTeamLogo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size35,
                    ),
                    UIHelper.verticalSpaceSmall,
                    Text(
                      matchHistory.getMyTeamName + '\n',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textStyleSemiBold(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${matchHistory.getMyTeamScore} - ${matchHistory.getOpponentTeamScore}',
                      textAlign: TextAlign.center,
                      style: textStyleBold(size: 22),
                    ),
                    UIHelper.verticalSpaceMedium,
                    matchHistory.getStatus == null
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                index == 0 ? Images.UP : Images.DOWN,
                                width: UIHelper.size(12),
                                height: UIHelper.size(12),
                                color: index == 0 ? Colors.green : Colors.red,
                              ),
                              Text(
                                '32.1',
                                style: textStyleSemiBold(
                                    size: 14,
                                    color:
                                        index == 0 ? Colors.green : Colors.red),
                              )
                            ],
                          )
                        : Text(
                            matchHistory.getStatus,
                            style: textStyleRegularBody(color: Colors.grey),
                          )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    ImageWidget(
                      source: matchHistory.getOpponentLogo,
                      placeHolder: Images.DEFAULT_LOGO,
                      size: UIHelper.size35,
                    ),
                    UIHelper.verticalSpaceSmall,
                    Text(
                      matchHistory.getOpponentName + '\n',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: textStyleSemiBold(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
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
                            padding:
                                EdgeInsets.symmetric(vertical: UIHelper.size10),
                            itemBuilder: (c, index) => _buildItemHistory(
                                  context,
                                  index,
                                  model.matchHistories[index],
                                  onSubmit:
                                      (historyId, firstScore, secondScore) =>
                                          model.updateScore(index, historyId,
                                              firstScore, secondScore),
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
