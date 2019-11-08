import 'package:flutter/material.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/models/user.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet_widget.dart';
import 'package:myfootball/ui/widgets/item_member.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:provider/provider.dart';

class MemberPage extends StatelessWidget {
  final List<Member> members;
  final int managerId;

  MemberPage({@required this.members, @required this.managerId});

  void _showClearPoints(BuildContext context) => showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Reset điểm thành viên', 'Huỷ'],
        ),
      );

  void _showManagerOptions(BuildContext context, Member member) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Xem chi tiết',
            'Đánh giá',
            'Xoá khỏi đội',
            'Huỷ'
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
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
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: isManager
                ? AppBarButtonWidget(
                    imageName: Images.MORE,
                    onTap: () => _showClearPoints(context),
                  )
                : AppBarButtonWidget(),
          ),
          Expanded(
            child: BorderBackground(
              child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: UIHelper.size15),
                  itemBuilder: (c, index) {
                    Member _member = members[index];
                    return ItemMember(
                        member: _member,
                        isCaptain: _member.id == managerId,
                        onTap: () {
                          if (isManager) {
                            _showManagerOptions(context, _member);
                          }
                        });
                  },
                  separatorBuilder: (c, index) => UIHelper.verticalIndicator,
                  itemCount: members.length),
            ),
          ),
        ],
      ),
    );
  }
}
