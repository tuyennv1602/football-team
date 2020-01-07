import 'package:flutter/material.dart';
import 'package:myfootball/model/fund.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/loadmore_loading.dart';
import 'package:myfootball/view/widget/refresh_loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/team_fund_vm.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TeamFundPage extends StatelessWidget {
  final RefreshController _fundController = RefreshController();

  _showOptions(BuildContext context,
          {Function onSendRequest, Function onDetail}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Gửi yêu cầu xác nhận đóng quỹ',
            'Xem danh sách đóng quỹ',
            'Huỷ'
          ],
          onClickOption: (index) {
            if (index == 1) {
              onSendRequest();
            }
            if (index == 2) {
              onDetail();
            }
          },
        ),
      );

  Widget _buildItemFund(BuildContext context, Fund fund,
          {Function onSendRequest, Function onDetail}) =>
      BorderItem(
        onTap: () => fund.status == 1
            ? onDetail(fund)
            : _showOptions(
                context,
                onSendRequest: () => onSendRequest(fund.id),
                onDetail: () => onDetail(fund),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Text(
                fund.title,
                style: textStyleMediumTitle(),
              ),
            ),
            Text(
              'Số tiền: ${fund.getPrice}',
              style: textStyleRegular(),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'Hạn thu: ${fund.getExpiredDate}',
                    style: textStyleRegular(),
                  ),
                ),
                StatusIndicator(
                    status: fund.getStatus, statusName: fund.getStatusName),
              ],
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    var teamId = Provider.of<Team>(context).id;
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          CustomizeAppBar(
            centerContent: Text(
              'Thông báo đóng quỹ',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButton(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<TeamFundViewModel>(
                model: TeamFundViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getFunds(teamId, false),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.funds.length == 0
                        ? EmptyWidget(message: 'Chưa có thông báo nào')
                        : SmartRefresher(
                            controller: _fundController,
                            enablePullDown: true,
                            enablePullUp: model.canLoadMore,
                            footer: LoadMoreLoading(),
                            header: RefreshLoading(),
                            onRefresh: () async {
                              await model.getFunds(teamId, true);
                              _fundController.refreshCompleted();
                            },
                            onLoading: () async {
                              await model.getFunds(teamId, false);
                              _fundController.loadComplete();
                            },
                            child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                    vertical: UIHelper.padding),
                                itemBuilder: (c, index) => _buildItemFund(
                                      context,
                                      model.funds[index],
                                      onSendRequest: (noticeId) =>
                                          model.sendRequest(index, noticeId),
                                      onDetail: (fund) => Navigation.instance
                                          .navigateTo(FUND_REQUEST,
                                              arguments: fund),
                                    ),
                                separatorBuilder: (c, index) =>
                                    UIHelper.verticalIndicator,
                                itemCount: model.funds.length),
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
