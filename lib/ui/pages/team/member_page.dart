import 'package:flutter/material.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app-bar-button.dart';
import 'package:myfootball/ui/widgets/app-bar-widget.dart';
import 'package:myfootball/ui/widgets/border-background.dart';
import 'package:myfootball/ui/widgets/button-widget.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image-widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/utils/ui-helper.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberPage extends StatelessWidget {
  final List<Member> _members;
  final int _managerId;

  MemberPage({@required List<Member> members, int managerId})
      : _members = members,
        _managerId = managerId;

  Widget _buildPosition(String position) {
    Color _color;
    switch (position) {
      case 'FW':
        _color = FW;
        break;
      case 'MF':
        _color = MF;
        break;
      case 'DF':
        _color = DF;
        break;
      case 'GK':
        _color = GK;
        break;
    }
    return Container(
      height: UIHelper.size20,
      decoration: BoxDecoration(
          color: _color, borderRadius: BorderRadius.circular(UIHelper.size10)),
      padding: EdgeInsets.symmetric(horizontal: UIHelper.size(7)),
      margin: EdgeInsets.only(
          left: UIHelper.size5,
          top: UIHelper.size(3),
          bottom: UIHelper.size(3)),
      child: Text(
        position,
        style: textStyleRegular(color: Colors.white),
      ),
    );
  }

  Widget _buildItemMember(BuildContext context, Member member) {
    bool isCapital = member.id == _managerId;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.size20, vertical: UIHelper.size10),
      child: Row(
        children: <Widget>[
          ImageWidget(
            source: member.avatar,
            placeHolder: Images.DEFAULT_AVATAR,
            size: UIHelper.size50,
            radius: UIHelper.size25,
          ),
          UIHelper.horizontalSpaceMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isCapital
                    ? RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: member.userName,
                              style: textStyleRegularTitle(),
                            ),
                            TextSpan(
                                text: ' (C)',
                                style: textStyleRegularTitle(color: Colors.red))
                          ],
                        ),
                      )
                    : Text(
                        member.userName,
                        style: textStyleRegularTitle(),
                      ),
                Text(
                  'Điểm cá nhân: ${member.getRating}',
                  style: textStyleRegularBody(),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Vị trí',
                      style: textStyleRegularBody(),
                    ),
                  ]..addAll(member.getPositions
                      .map<Widget>((pos) => _buildPosition(pos))),
                ),
              ],
            ),
          ),
          ButtonWidget(
              width: UIHelper.size40,
              height: UIHelper.size40,
              borderRadius: BorderRadius.circular(UIHelper.size20),
              child: Padding(
                padding: EdgeInsets.all(UIHelper.size10),
                child: Image.asset(
                  Images.PHONE,
                  fit: BoxFit.contain,
                  color: PRIMARY,
                ),
              ),
              onTap: () => launch('tel://${member.phone}'))
        ],
      ),
    );
  }

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
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
                      itemBuilder: (c, index) =>
                          _buildItemMember(context, _members[index]),
                      separatorBuilder: (c, index) => LineWidget(),
                      itemCount: _members.length)
                  : EmptyWidget(message: 'Không có thành viên nào'),
            ),
          ),
        ],
      ),
    );
  }
}
