import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/item_option.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/setup_team_viewmodel.dart';
import 'package:provider/provider.dart';

class SetupTeamPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: ListView(
                padding: EdgeInsets.zero,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  ItemOptionWidget(
                    Images.EDIT_TEAM,
                    'Chỉnh sửa thông tin',
                    iconColor: Colors.green,
                    onTap: () => Navigation.instance.navigateTo(EDIT_TEAM_INFO),
                  ),
                  BaseWidget<SetupTeamViewModel>(
                    model: SetupTeamViewModel(
                        api: Provider.of(context),
                        teamServices: Provider.of(context)),
                    onModelReady: (model) {
                      model.initActive(_team.isSearching);
                    },
                    builder: (c, model, child) => ItemOptionWidget(
                      Images.RECEIVE_INVITE,
                      'Nhận yêu cầu ghép đối',
                      iconColor: Colors.lightBlue,
                      rightContent: SizedBox(
                        width: UIHelper.size(60),
                        height: UIHelper.size30,
                        child: Switch(
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
                              await model.inActiveMatching(_team.id);
                              UIHelper.hideProgressDialog;
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  ItemOptionWidget(
                    Images.FIND_MATCH,
                    'Thiết lập thông tin ghép đối',
                    iconColor: Colors.red,
                    onTap: () => Navigation.instance.navigateTo(SETUP_MATCHING),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
