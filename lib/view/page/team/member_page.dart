import 'package:flutter/material.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/item_member.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/member_viewmodel.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MemberPage extends StatelessWidget {
  Team team;

  MemberPage({this.team});

  void _showManagerOptions(BuildContext context,
          {Function onDetail, Function onAddCaptain, Function onRemove}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: [
            'Tuỳ chọn',
            'Thông tin cá nhân',
            'Thêm quyền đội trưởng',
            'Xoá khỏi đội',
            'Huỷ'
          ],
          onClickOption: (index) {
            if (index == 1) {
              onDetail();
            }
            if (index == 2) {
              onAddCaptain();
            }
            if (index == 3) {
              onRemove();
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (team == null) {
      team = Provider.of<Team>(context);
    }
    var isManager = Provider.of<User>(context).id == team.managerId;
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
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<MemberViewModel>(
                model: MemberViewModel(
                  api: Provider.of(context),
                  team: team,
                  teamServices: Provider.of(context),
                ),
                builder: (c, model, child) {
                  var members = team.members;
                  return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(UIHelper.padding),
                    itemBuilder: (c, index) {
                      Member _member = members[index];
                      return ItemMember(
                        member: _member,
                        isManager: _member.id == model.team.managerId,
                        isCaptain: _member.id == model.team.captainId,
                        onTap: () async {
                          if (isManager && _member.id != model.team.managerId) {
                            _showManagerOptions(
                              context,
                              onDetail: () {
                                Navigation.instance.navigateTo(
                                    MEMBER_DETAIL,
                                    arguments: _member);
                              },
                              onAddCaptain: () => UIHelper.showConfirmDialog(
                                'Bạn có chắc chắn muốn thêm quyền đội trưởng cho ${_member.name}?',
                                onConfirmed: () => model.addCaptain(_member.id),
                              ),
                              onRemove: () => UIHelper.showConfirmDialog(
                                'Bạn có chắc chắn muốn xoá ${_member.name} khỏi đội bóng?',
                                onConfirmed: () =>
                                    model.kickMember(index, _member.id),
                              ),
                            );
                          } else {
                            Navigation.instance
                                .navigateTo(MEMBER_DETAIL, arguments: _member);
                          }
                        },
                      );
                    },
                    itemCount: members.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: UIHelper.padding,
                        mainAxisSpacing: UIHelper.padding),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
