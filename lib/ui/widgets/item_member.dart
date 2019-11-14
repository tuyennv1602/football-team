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
  final Member member;
  final bool isCaptain;
  final Function onTap;

  const ItemMember(
      {Key key, @required this.member, @required this.isCaptain, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.size15),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.size15),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    isCaptain
                        ? RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: member.userName,
                                  style: textStyleSemiBold(),
                                ),
                                TextSpan(
                                    text: ' (C)',
                                    style: textStyleSemiBold(color: Colors.red))
                              ],
                            ),
                          )
                        : Text(
                            member.userName,
                            style: textStyleSemiBold(),
                          ),
                    member.rating != null
                        ? Text(
                            'Điểm cá nhân: ${member.rating}',
                            style: textStyleRegular(),
                          )
                        : SizedBox(),
                    member.position != null && member.position.length > 0
                        ? Row(
                            children: member.getPositions
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
                  onTap: () => launch('tel://${member.phone}'))
            ],
          ),
        ),
      ),
    );
  }
}
