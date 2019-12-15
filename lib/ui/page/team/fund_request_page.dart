import 'package:flutter/material.dart';
import 'package:myfootball/model/fund.dart';
import 'package:myfootball/model/fund_member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/border_item.dart';
import 'package:myfootball/ui/widget/empty_widget.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/ui/widget/status_indicator.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/fund_request_viewmodel.dart';
import 'package:provider/provider.dart';

class FundRequestPage extends StatelessWidget {
  final Fund fund;

  const FundRequestPage({Key key, this.fund}) : super(key: key);

  Widget _buildItemRequest(int index, FundMember member, {Function onTap}) =>
      BorderItemWidget(
        onTap: () => onTap(member),
        child: Row(
          children: <Widget>[
            ImageWidget(
              source: member.avatar,
              placeHolder: Images.DEFAULT_AVATAR,
              size: UIHelper.size40,
              radius: UIHelper.size20,
              boxFit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(left: UIHelper.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    member.name,
                    style: textStyleMediumTitle(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: UIHelper.size5),
                    child: StatusIndicator(
                      statusName: member.getStatusName,
                      status: member.getStatus,
                    ),
                  )
                ],
              ),
            ),
          ],
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
                                    if (team.hasManager(user.id) &&
                                        member.isActive) {
                                      UIHelper.showConfirmDialog(
                                        'Xác nhận ${member.name} đã đóng quỹ?',
                                        onConfirmed: () => model.acceptRequest(
                                            index, member.requestId),
                                      );
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
