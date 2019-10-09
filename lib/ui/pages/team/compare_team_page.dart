import 'package:flutter/material.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/clipper_left_widget.dart';
import 'package:myfootball/ui/widgets/clipper_right_widget.dart';
import 'package:myfootball/ui/widgets/compare_team_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

class CompareTeamPage extends StatelessWidget {
  final Team _team2;

  CompareTeamPage({@required Team team}) : _team2 = team;

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    Team _team1 = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Mời ghép đối',
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
                children: <Widget>[
                  CompareTeamWidget(team1: _team1, team2: _team2),
                  ButtonWidget(
                      child: Text(
                        'GỬI LỜI MỜI',
                        style: textStyleButton(),
                      ),
                      margin: EdgeInsets.all(UIHelper.size15),
                      onTap: () {})
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
