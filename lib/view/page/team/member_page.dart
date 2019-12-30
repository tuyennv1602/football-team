import 'package:flutter/material.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/item_member.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          CustomizeAppBar(
            centerContent: Text(
              'Tất cả thành viên',
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
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(UIHelper.padding),
                itemBuilder: (c, index) {
                  Member _member = team.members[index];
                  return ItemMember(
                    member: _member,
                    isManager: _member.id == team.managerId,
                    isCaptain: _member.id == team.captainId,
                    onTap: () => Navigation.instance
                        .navigateTo(MEMBER_DETAIL, arguments: _member),
                  );
                },
                itemCount: team.members.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: UIHelper.padding,
                    mainAxisSpacing: UIHelper.size15),
              ),
            ),
          )
        ],
      ),
    );
  }
}
