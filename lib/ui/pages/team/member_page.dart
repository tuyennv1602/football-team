import 'package:flutter/material.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/member_arg.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/item_member.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

class MemberPage extends StatelessWidget {
  final List<Member> members;
  final int managerId;

  MemberPage({@required this.members, @required this.managerId});

  void _showManagerOptions(BuildContext context, {Function onDetail}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Xem hồ sơ', 'Xoá khỏi đội', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              onDetail();
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    var isManager = Provider.of<User>(context).id == managerId;
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
              onTap: () => NavigationService.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(UIHelper.padding),
                itemBuilder: (c, index) {
                  Member _member = members[index];
                  return ItemMember(
                    member: _member,
                    isCaptain: _member.id == managerId,
                    onTap: () async {
                      if (isManager) {
                        _showManagerOptions(
                          context,
                          onDetail: () async {
                            var rating = NavigationService.instance.navigateTo(
                                MEMBER_DETAIL,
                                arguments: MemberArgument(member: _member));
                            print(rating);
                          },
                        );
                      } else {
                        var rating = NavigationService.instance.navigateTo(
                            MEMBER_DETAIL,
                            arguments: MemberArgument(member: _member));
                        print(rating);
                      }
                    },
                  );
                },
                itemCount: members.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: UIHelper.size10,
                    mainAxisSpacing: UIHelper.size10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
