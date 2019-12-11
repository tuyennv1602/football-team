import 'package:flutter/material.dart';
import 'package:myfootball/model/match_schedule.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/ui/widget/border_item.dart';
import 'package:myfootball/utils/ui_helper.dart';

import 'clipper_right_widget.dart';
import 'image_widget.dart';
import 'line.dart';

class ItemMatchSchedule extends StatelessWidget {
  final MatchSchedule matchSchedule;
  final Function onTapSchedule;

  ItemMatchSchedule(
      {Key key, @required this.matchSchedule, @required this.onTapSchedule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _hasReceiveTeam = matchSchedule.receiveTeam != null;
    return BorderItemWidget(
      padding: EdgeInsets.zero,
      onTap: onTapSchedule,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: UIHelper.size35,
            margin: EdgeInsets.only(top: UIHelper.size10),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
                  child: ImageWidget(
                    source: matchSchedule.getMyTeamLogo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size35,
                  ),
                ),
                Expanded(
                  child: Text(
                    matchSchedule.getMyTeamName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleMediumTitle(),
                  ),
                ),
                Container(
                  width: 3,
                  color: parseColor(matchSchedule.getMyTeam.dress),
                ),
              ],
            ),
          ),
          Container(
            height: UIHelper.size20,
            padding: EdgeInsets.only(left: UIHelper.size(60)),
            child: Row(
              children: <Widget>[
                Text(
                  'VS',
                  style: textStyleMedium(size: 12, color: Colors.grey),
                ),
                Expanded(child: LineWidget())
              ],
            ),
          ),
          Container(
            height: _hasReceiveTeam ? UIHelper.size35 : UIHelper.size20,
            child: _hasReceiveTeam
                ? Row(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: UIHelper.size10),
                        child: ImageWidget(
                          source: matchSchedule.getOpponentLogo,
                          placeHolder: Images.DEFAULT_LOGO,
                          size: UIHelper.size35,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          matchSchedule.getOpponentName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyleMedium(),
                        ),
                      ),
                      Container(
                        width: 3,
                        color: parseColor(matchSchedule.getOpponentTeam.dress),
                      ),
                    ],
                  )
                : SizedBox(),
          ),
          Container(
            height: UIHelper.size30,
            margin: EdgeInsets.only(top: UIHelper.size10),
            decoration: BoxDecoration(
                color: LIGHT_GREEN,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(UIHelper.padding))),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: UIHelper.size10, right: UIHelper.size5),
                    child: Text(
                      matchSchedule.groundName,
                      style: textStyleMedium(color: Colors.grey),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(UIHelper.padding),
                      topLeft: Radius.circular(UIHelper.size50)),
                  child: ClipPath(
                    clipper: ClipperRightWidget(),
                    child: Container(
                      height: UIHelper.size30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF02DC37), PRIMARY],
                        ),
                      ),
                      padding: EdgeInsets.only(
                          left: UIHelper.size15, right: UIHelper.size10),
                      child: Text(
                        matchSchedule.getShortPlayTime,
                        style: textStyleMedium(color: Colors.white),
                      ),
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
