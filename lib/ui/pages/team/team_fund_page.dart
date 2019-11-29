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
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/team_fund_viewmodel.dart';
import 'package:provider/provider.dart';

class TeamFundPage extends StatelessWidget {

  Widget _buildItemFund(BuildContext context, Fund fund) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.padding),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
        child: InkWell(
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
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Số tiền: ',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: REGULAR,
                            fontSize: UIHelper.size(17)),
                      ),
                      TextSpan(
                        text: fund.getPrice,
                        style: TextStyle(
                            fontFamily: SEMI_BOLD,
                            color: Colors.black,
                            fontSize: UIHelper.size(17)),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Hạn đóng: ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: REGULAR,
                                fontSize: UIHelper.size(17)),
                          ),
                          TextSpan(
                            text: fund.getExpiredDate,
                            style: TextStyle(
                                fontFamily: SEMI_BOLD,
                                color: Colors.black,
                                fontSize: UIHelper.size(17)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        fund.status == 0 ? 'Chưa đóng' : 'Đã đóng',
                        textAlign: TextAlign.right,
                        style: textStyleRegularBody(
                            color:
                                fund.status == 0 ? Colors.green : Colors.green),
                      ),
                    )
                  ],
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
                            itemBuilder: (c, index) =>
                                _buildItemFund(context, model.funds[index]),
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
