import 'package:flutter/material.dart';
import 'package:myfootball/models/fund.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/step_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/team_fund_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamFundPage extends StatelessWidget {
  _showOptions(BuildContext context,
          {Function onSendRequest, Function onViewList}) =>
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
              onViewList();
            }
          },
        ),
      );

  Widget _buildItemFund(BuildContext context, Fund fund,
          {Function onSendRequest, Function onViewList}) =>
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
            onViewList: () => onViewList(fund.id),
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
                    style: textStyleSemiBold(),
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
                  thirdTitle: 'Đã đóng',
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
                                ),
                            separatorBuilder: (c, index) =>
                                UIHelper.verticalIndicator,
                            itemCount: model.funds.length),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
