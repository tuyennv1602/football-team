import 'package:flutter/material.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/item_match_schedule.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/tabbar_widget.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
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
                        onModelReady: (model) => model.getUserJoinRequest(1),
                        builder: (c, model, child) => TabBarView(
                          children: <Widget>[
                            model.busy
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
                                            onTapSchedule: () =>
                                                _showWaitingOptions(
                                              context,
                                              onDetail: () => Navigation
                                                  .instance
                                                  .navigateTo(
                                                      MATCH_SCHEDULE_DETAIL,
                                                      arguments: matchInfo),
                                              onCancel: () =>
                                                  UIHelper.showConfirmDialog(
                                                'Bạn có chắc chắn muốn huỷ yêu cầu tham gia trận đấu',
                                                onConfirmed: () =>
                                                    model.cancelJoinRequest(
                                                        0,
                                                        index,
                                                        model
                                                            .waitRequests[index]
                                                            .matchUserId),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (c, index) =>
                                            UIHelper.verticalIndicator,
                                        itemCount: model.waitRequests.length),
                            model.busy
                                ? LoadingWidget()
                                : model.acceptedRequest.length == 0
                                    ? EmptyWidget(
                                        message: 'Chưa có trận đấu nào')
                                    : ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIHelper.padding),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (c, index) {
                                          var matchInfo = model
                                              .acceptedRequest[index].matchInfo;
                                          return ItemMatchSchedule(
                                            matchSchedule: matchInfo,
                                            onTapSchedule: () =>
                                                _showWaitingOptions(
                                              context,
                                              onDetail: () => Navigation
                                                  .instance
                                                  .navigateTo(
                                                      MATCH_SCHEDULE_DETAIL,
                                                      arguments: matchInfo),
                                              onCancel: () =>
                                                  UIHelper.showConfirmDialog(
                                                'Bạn có chắc chắn muốn huỷ tham gia trận đấu?',
                                                onConfirmed: () =>
                                                    model.cancelJoinRequest(
                                                        1,
                                                        index,
                                                        model
                                                            .acceptedRequest[
                                                                index]
                                                            .matchUserId),
                                              ),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (c, index) =>
                                            UIHelper.verticalIndicator,
                                        itemCount:
                                            model.acceptedRequest.length),
                            model.busy
                                ? LoadingWidget()
                                : model.joined.length == 0
                                    ? EmptyWidget(
                                        message: 'Chưa có trận đấu nào')
                                    : ListView.separated(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIHelper.padding),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (c, index) {
                                          var matchInfo =
                                              model.joined[index].matchInfo;
                                          return ItemMatchSchedule(
                                            matchSchedule: matchInfo,
                                            onTapSchedule: () =>
                                                Navigation.instance
                                                    .navigateTo(
                                                        MATCH_SCHEDULE_DETAIL,
                                                        arguments: matchInfo),
                                          );
                                        },
                                        separatorBuilder: (c, index) =>
                                            UIHelper.verticalIndicator,
                                        itemCount: model.joined.length),
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
