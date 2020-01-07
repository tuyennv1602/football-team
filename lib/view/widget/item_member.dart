import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/view/widget/hexagonal_clipper.dart';
import 'package:myfootball/view/widget/line.dart';
import 'customize_image.dart';

class ItemMember extends StatelessWidget {
  final Member member;
  final bool isCaptain;
  final bool isManager;
  final Function onTap;
  final bool isFullInfo;

  const ItemMember(
      {Key key,
      @required this.member,
      @required this.isManager,
      this.isCaptain = false,
      this.onTap,
      this.isFullInfo = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderItem(
      onTap: onTap,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          isManager || isCaptain
              ? Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: UIHelper.size30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isManager ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(UIHelper.padding),
                        bottomRight: Radius.circular(UIHelper.padding),
                      ),
                    ),
                    child: Text(
                      isManager ? 'M' : 'C',
                      style: textStyleSemiBold(size: 14, color: Colors.white),
                    ),
                  ),
                )
              : SizedBox(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                      child: Hero(
                        tag: member.tag,
                        child: CustomizeImage(
                          source: member.avatar,
                          placeHolder: Images.DEFAULT_AVATAR,
                          radius: UIHelper.size(55) / 2,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    member.number != null
                        ? Positioned(
                            bottom: 2,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: UIHelper.size5,
                              ),
                              constraints: BoxConstraints(
                                minWidth: UIHelper.size25
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.circular(UIHelper.size10),
                                border: Border.all(color: Colors.white),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFF02DC37), PRIMARY],
                                ),
                              ),
                              child: Text(
                                member.number,
                                textAlign: TextAlign.center,
                                style: textStyleSemiBold(
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                Text(
                  member.name,
                  style: textStyleSemiBold(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Exp: ',
                              style: textStyleRegularBody(color: Colors.grey),
                            ),
                            Text(
                              member.getExp,
                              style: textStyleMedium(size: 15),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Trận: ',
                              style: textStyleRegularBody(color: Colors.grey),
                            ),
                            Text(
                              member.teamGame.toString(),
                              style: textStyleMedium(size: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
