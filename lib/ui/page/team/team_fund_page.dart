import 'package:flutter/material.dart';
import 'package:myfootball/model/fund.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/bottom_sheet.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/step_widget.dart';
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

  Widget _buildItemFund(BuildContext context, Fund fund,
          {Function onSendRequest, Function onDetail}) =>
      Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.padding),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
        child: InkWell(
          onTap: () => _showOptions(
            context,
            onSendRequest: () => onSendRequest(fund.id),
            onDetail: () => onDetail(fund),
          ),
          child: Padding(
            padding: EdgeInsets.all(UIHelper.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: UIHelper.size5),
                  child: Text(
                    fund.title,
                    style: textStyleMediumTitle(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Số tiền: ${fund.getPrice}',
                      style: textStyleRegular(),
                    ),
                    Text(
                      'Exp: ${fund.getExpiredDate}',
                      style: textStyleRegular(),
                    ),
                  ],
                ),
                UIHelper.verticalSpaceMedium,
                LineWidget(indent: 0),
                UIHelper.verticalSpaceMedium,
                StepWidget(
                  step: fund.getStep,
                  firstTitle: 'Chưa đóng',
                  secondTitle: 'Chờ xác nhận',
                  thirdTitle: 'Hoàn thành',
                )
              ],
            ),
          ),
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
              'Thông báo đóng quỹ',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance.goBack(),
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
                                      model.sendRequest(index, noticeId),
                                  onDetail: (fund) => NavigationService.instance
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
