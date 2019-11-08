import 'package:flutter/material.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'button_widget.dart';
import 'image_widget.dart';
import 'item_position.dart';

class ItemMember extends StatelessWidget {
  final Member _member;
  final bool _isCaptain;
  final Function _onTap;

  ItemMember(
      {@required Member member, @required bool isCaptain, Function onTap})
      : _member = member,
        _isCaptain = isCaptain,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.size15),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.size15),
      child: InkWell(
        onTap: _onTap,
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageWidget(
                source: _member.avatar,
                placeHolder: Images.DEFAULT_AVATAR,
                size: UIHelper.size50,
                radius: UIHelper.size25,
              ),
              UIHelper.horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _isCaptain
                        ? RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: _member.userName,
                                  style: textStyleSemiBold(),
                                ),
                                TextSpan(
                                    text: ' (C)',
                                    style: textStyleSemiBold(color: Colors.red))
                              ],
                            ),
                          )
                        : Text(
                            _member.userName,
                            style: textStyleSemiBold(),
                          ),
                    Text(
                      'Điểm cá nhân: ${_member.getRating}',
                      style: textStyleRegular(),
                    ),
                    _member.position != null && _member.position.length > 0
                        ? Row(
                            children: _member.getPositions
                                .map<Widget>(
                                  (pos) => ItemPosition(
                                    position: pos,
                                  ),
                                )
                                .toList(),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              ButtonWidget(
                  width: UIHelper.size40,
                  height: UIHelper.size40,
                  borderRadius: BorderRadius.circular(UIHelper.size20),
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(UIHelper.size10),
                    child: Image.asset(
                      Images.CALL,
                      fit: BoxFit.contain,
                      color: PRIMARY,
                    ),
                  ),
                  onTap: () => launch('tel://${_member.phone}'))
            ],
          ),
        ),
      ),
    );
  }
}
