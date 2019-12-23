import 'package:flutter/material.dart';
import 'package:myfootball/model/fund.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/status_indicator.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/team_fund_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamFundPage extends StatelessWidget {
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

  _buildItemFund(BuildContext context, Fund fund,
          {Function onSendRequest, Function onDetail}) =>
      BorderItemWidget(
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

  _handleSendRequest(int index, int noticeId, TeamFundViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.sendRequest(index, noticeId);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog(
          'Yêu cầu của bạn đã được gửi. Vui lòng chờ xác nhận',
          isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Thông báo đóng quỹ',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<TeamFundViewModel>(
                model: TeamFundViewModel(api: Provider.of(context)),
                onModelReady: (model) =>
                    model.getFunds(Provider.of<Team>(context).id),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.funds.length == 0
                        ? EmptyWidget(message: 'Chưa có thông báo nào')
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(
                                vertical: UIHelper.padding),
                            itemBuilder: (c, index) => _buildItemFund(
                                  context,
                                  model.funds[index],
                                  onSendRequest: (noticeId) =>
                                      _handleSendRequest(
                                          index, noticeId, model),
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
          UIHelper.homeButtonSpace
        ],
      ),
    );
  }
}