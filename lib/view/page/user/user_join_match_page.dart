import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/item_match_history.dart';
import 'package:myfootball/view/widget/item_match_schedule.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/tabbar_widget.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/user_join_match_vm.dart';
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
            leftContent: AppBarButton(
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
                                          var request =
                                              model.waitRequests[index];
                                          return ItemMatchSchedule(
                                            matchSchedule: request.matchInfo,
                                            onTapSchedule: () =>
                                                _showWaitingOptions(
                                              context,
                                              onDetail: () => Navigation
                                                  .instance
                                                  .navigateTo(
                                                      MATCH_SCHEDULE_DETAIL,
                                                      arguments:
                                                          request.matchInfo),
                                              onCancel: () =>
                                                  UIHelper.showConfirmDialog(
                                                'Bạn có chắc chắn muốn huỷ yêu cầu tham gia trận đấu',
                                                onConfirmed: () =>
                                                    model.cancelJoinRequest(
                                                        0,
                                                        index,
                                                        request.matchUserId),
                                              ),
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
                                          var request =
                                              model.acceptedRequests[index];
                                          return ItemMatchSchedule(
                                            matchSchedule: request.matchInfo,
                                            onTapSchedule: () =>
                                                _showWaitingOptions(
                                              context,
                                              onDetail: () => Navigation
                                                  .instance
                                                  .navigateTo(
                                                      MATCH_SCHEDULE_DETAIL,
                                                      arguments:
                                                          request.matchInfo),
                                              onCancel: () =>
                                                  UIHelper.showConfirmDialog(
                                                'Bạn có chắc chắn muốn huỷ tham gia trận đấu?',
                                                onConfirmed: () =>
                                                    model.cancelJoinRequest(
                                                        1,
                                                        index,
                                                        request.matchUserId),
                                              ),
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
