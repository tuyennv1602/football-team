import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:myfootball/viewmodels/setup_team_viewmodel.dart';
import 'package:provider/provider.dart';

class SetupTeamPage extends StatelessWidget {
  Widget _buildItemSetting(
          BuildContext context, String title, Function onTap) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: UIHelper.size15, horizontal: UIHelper.size20),
          child: Text(
            title,
            style: textStyleRegularTitle(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    Team _team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Thiết lập đội bóng',
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
              child: ListView(
                padding: EdgeInsets.zero,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  _buildItemSetting(context, 'Chỉnh sửa thông tin',
                          () => Routes.routeToSetupMatchingInfo(context)),
                  LineWidget(),
                  BaseWidget<SetupTeamViewModel>(
                    model: SetupTeamViewModel(
                        api: Provider.of(context),
                        teamServices: Provider.of(context)),
                    onModelReady: (model) {
                      model.initActive(_team.isSearching);
                    },
                    builder: (c, model, child) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: UIHelper.size20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Nhận yêu cầu ghép đối',
                            style: textStyleRegularTitle(),
                          ),
                          Switch(
                            activeColor: PRIMARY,
                            inactiveTrackColor: SHADOW_GREEN,
                            inactiveThumbColor: SHADOW_GREEN,
                            value: model.isActive,
                            onChanged: (isActive) async {
                              if (isActive) {
                                UIHelper.showProgressDialog;
                                await model.activeMatching(_team.id);
                                UIHelper.hideProgressDialog;
                              } else {
                                UIHelper.showProgressDialog;
                                model.inActiveMatching(_team.id);
                                UIHelper.hideProgressDialog;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  LineWidget(),
                  _buildItemSetting(context, 'Thiết lập thông tin ghép đối',
                      () => Routes.routeToSetupMatchingInfo(context))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
