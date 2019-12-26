import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/ui_helper.dart' as prefix0;
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/item_match_history.dart';
import 'package:myfootball/view/widget/item_match_schedule.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/tabbar_widget.dart';
import 'package:myfootball/view/router/router_paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/user_join_match_viewmodel.dart';
import 'package:provider/provider.dart';

class UserJoinMatchPage extends StatelessWidget {
  static const TABS = ['Đang chờ', 'Đã chấp nhận', 'Đã tham gia'];

  _showWaitingOptions(BuildContext context,
          {Function onDetail, Function onCancel}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Thông tin trận đấu', 'Huỷ yêu cầu', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              onDetail();
            }
            if (index == 2) {
              onCancel();
            }
          },
        ),
      );

  _handleCancel(
      int tab, int index, int matchUserId, UserJoinMatchViewModel model) {
    UIHelper.showConfirmDialog(
      'Bạn có chắc chắn muốn huỷ yêu cầu tham gia trận đấu',
      onConfirmed: () async {
        UIHelper.showProgressDialog;
        var resp = await model.cancelJoinRequest(tab, index, matchUserId);
        UIHelper.hideProgressDialog;
        if (resp.isSuccess) {
          UIHelper.showSimpleDialog('Đã huỷ tham gia trận đấu',
              isSuccess: true);
        } else {
          UIHelper.showSimpleDialog(resp.errorMessage);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Tham gia trận đấu',
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
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: <Widget>[
                    TabBarWidget(
                      titles: TABS,
                      height: UIHelper.size45,
                      isScrollable: true,
                    ),
                    Expanded(
                      child: BaseWidget<UserJoinMatchViewModel>(
                        model:
                            UserJoinMatchViewModel(api: Provider.of(context)),
                        onModelReady: (model) {
                          model.getPendingRequests(1);
                          model.getAcceptedRequest(1);
                          model.getJoinedMatch(1);
                        },
                        builder: (c, model, child) => TabBarView(
                          children: <Widget>[
                            model.isLoadingRequest
                                ? LoadingWidget()
                                : model.waitRequests.length == 0
                                    ? EmptyWidget(
                                        message: 'Chưa có yêu cầu nào')
                                    : ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIHelper.padding),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (c, index) {
                                          var matchInfo = model
                                              .waitRequests[index].matchInfo;
                                          return ItemMatchSchedule(
                                            matchSchedule: matchInfo,
                                            onTap: () => _showWaitingOptions(
                                              context,
                                              onDetail: () => Navigation
                                                  .instance
                                                  .navigateTo(
                                                      MATCH_SCHEDULE_DETAIL,
                                                      arguments: matchInfo),
                                              onCancel: () => _handleCancel(
                                                  0,
                                                  index,
                                                  model.waitRequests[index]
                                                      .matchUserId,
                                                  model),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (c, index) =>
                                            UIHelper.verticalIndicator,
                                        itemCount: model.waitRequests.length),
                            model.isLoadingAccepted
                                ? LoadingWidget()
                                : model.acceptedRequests.length == 0
                                    ? EmptyWidget(
                                        message: 'Chưa có trận đấu nào')
                                    : ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIHelper.padding),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (c, index) {
                                          var matchInfo = model
                                              .acceptedRequests[index]
                                              .matchInfo;
                                          return ItemMatchSchedule(
                                            matchSchedule: matchInfo,
                                            onTap: () => _showWaitingOptions(
                                              context,
                                              onDetail: () => Navigation
                                                  .instance
                                                  .navigateTo(
                                                      MATCH_SCHEDULE_DETAIL,
                                                      arguments: matchInfo),
                                              onCancel: () => _handleCancel(
                                                  1,
                                                  index,
                                                  model.acceptedRequests[index]
                                                      .matchUserId,
                                                  model),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (c, index) =>
                                            UIHelper.verticalIndicator,
                                        itemCount:
                                            model.acceptedRequests.length),
                            model.isLoadingJoined
                                ? LoadingWidget()
                                : model.joinedMatches.length == 0
                                    ? EmptyWidget(
                                        message: 'Chưa có trận đấu nào')
                                    : ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIHelper.padding),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (c, index) {
                                          var match =
                                              model.joinedMatches[index];
                                          return ItemMatchHistory(
                                            matchHistory: match,
                                            onTap: () => Navigation.instance
                                                .navigateTo(
                                                    MATCH_HISTORY_DETAIL,
                                                    arguments: match),
                                          );
                                        },
                                        separatorBuilder: (c, index) =>
                                            UIHelper.verticalIndicator,
                                        itemCount: model.joinedMatches.length),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
