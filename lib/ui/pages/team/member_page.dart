import 'package:flutter/material.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/item_member.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

class MemberPage extends StatelessWidget {
  final List<Member> _members;
  final int _managerId;

  MemberPage({@required List<Member> members, @required int managerId})
      : _members = members,
        _managerId = managerId;

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Tất cả thành viên',
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
              child: _members.length > 0
                  ? ListView.separated(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                      itemBuilder: (c, index) {
                        Member _member = _members[index];
                        return ItemMember(
                          member: _member,
                          isCaptain: _member.id == _managerId,
                        );
                      },
                      separatorBuilder: (c, index) => SizedBox(height: UIHelper.size10),
                      itemCount: _members.length)
                  : EmptyWidget(message: 'Không có thành viên nào'),
            ),
          ),
        ],
      ),
    );
  }
}
