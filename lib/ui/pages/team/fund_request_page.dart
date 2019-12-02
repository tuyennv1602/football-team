import 'package:flutter/material.dart';
import 'package:myfootball/models/fund.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/status_indicator.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/fund_request_viewmodel.dart';
import 'package:provider/provider.dart';

class FundRequestPage extends StatelessWidget {
  final Fund fund;

  const FundRequestPage({Key key, this.fund}) : super(key: key);

  Widget _buildItemRequest(int index, Member member, {Function onTap}) => Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.padding),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.padding),
        child: InkWell(
          onTap: () => onTap(member),
          child: Padding(
            padding: EdgeInsets.all(UIHelper.padding),
            child: Row(
              children: <Widget>[
                ImageWidget(
                  source: member.avatar,
                  placeHolder: Images.DEFAULT_AVATAR,
                  size: UIHelper.size40,
                  radius: UIHelper.size20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: UIHelper.padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        member.name,
                        style: textStyleMediumTitle(),
                      ),
                      UIHelper.verticalSpaceSmall,
                      StatusIndicator(
                        isActive: member.isActive,
                        status: member.getFundStatus,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    var user = Provider.of<User>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              fund.title,
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
              child: BaseWidget<FundRequestViewModel>(
                model: FundRequestViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.getFundsStatus(team.id, fund.id),
                builder: (c, model, child) => model.busy
                    ? LoadingWidget()
                    : model.members.length == 0
                        ? EmptyWidget(message: 'Chưa có thông tin đóng quỹ')
                        : ListView.separated(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                vertical: UIHelper.padding),
                            itemBuilder: (c, index) => _buildItemRequest(
                                  index,
                                  model.members[index],
                                  onTap: (member) {
                                    if (team.isManager(user.id) && member.isActive) {
                                      UIHelper.showConfirmDialog(
                                          'Xác nhận ${member.name} đã đóng quỹ?',
                                          onConfirmed: () {});
                                    }
                                  },
                                ),
                            separatorBuilder: (c, index) =>
                                UIHelper.verticalIndicator,
                            itemCount: model.members.length),
              ),
            ),
          ),
          UIHelper.homeButtonSpace
        ],
      ),
    );
  }
}
