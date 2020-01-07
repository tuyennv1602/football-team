
import 'package:flutter/material.dart';
import 'package:myfootball/model/match_history.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/customize_image.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/status_indicator.dart';

class ItemMatchHistory extends StatelessWidget {
  final MatchHistory matchHistory;
  final Function onTap;
  const ItemMatchHistory({Key key, this.matchHistory, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BorderItem(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
          vertical: UIHelper.padding, horizontal: UIHelper.size10),
      child: Column(
        children: <Widget>[
          Container(
            height: UIHelper.size35,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: UIHelper.size10),
                  child:  CustomizeImage(
                    source: matchHistory.getMyTeamLogo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size35,
                  ),
                ),
                Expanded(
                  child: Text(
                    matchHistory.getMyTeamName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleMediumTitle(),
                  ),
                ),
                Text(
                  matchHistory.getMyTeamScore,
                  style: textStyleBold(
                      size: 20,
                      color: matchHistory.isConfirmed
                          ? Colors.black
                          : Colors.grey),
                )
              ],
            ),
          ),
          matchHistory.hasOpponentTeam
              ? Container(
            height: UIHelper.size20,
            padding: EdgeInsets.only(left: UIHelper.size45),
            child: Row(
              children: <Widget>[
                Text(
                  'VS',
                  style: textStyleMedium(size: 12, color: Colors.grey),
                ),
                Expanded(child: LineWidget())
              ],
            ),
          )
              : SizedBox(),
          Container(
            height: matchHistory.hasOpponentTeam ? UIHelper.size35 : 0,
            child: matchHistory.hasOpponentTeam
                ? Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: UIHelper.size10),
                  child: CustomizeImage(
                    source: matchHistory.getOpponentLogo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size35,
                  ),
                ),
                Expanded(
                  child: Text(
                    matchHistory.getOpponentName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyleMediumTitle(),
                  ),
                ),
                Text(
                  matchHistory.getOpponentTeamScore,
                  style: textStyleBold(
                      size: 20,
                      color: matchHistory.isConfirmed
                          ? Colors.black
                          : Colors.grey),
                )
              ],
            )
                : SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: UIHelper.padding),
            child: LineWidget(indent: 0),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Row(
                    children: <Widget>[
                      matchHistory.getMyTeamPoint != null
                          ? Text(
                        matchHistory.getMyTeamPoint.toStringAsFixed(2),
                        style: textStyleMedium(
                            size: 14,
                            color: matchHistory.getMyTeamPoint > 0
                                ? GREEN_TEXT
                                : Colors.red),
                      )
                          : SizedBox(),
                      matchHistory.getMyTeamPoint != null
                          ? Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Image.asset(
                          matchHistory.getMyTeamPoint > 0
                              ? Images.UP
                              : Images.DOWN,
                          width: UIHelper.size(12),
                          height: UIHelper.size(12),
                          color: matchHistory.getMyTeamPoint > 0
                              ? GREEN_TEXT
                              : Colors.red,
                        ),
                      )
                          : SizedBox(),
                      matchHistory.countConfirmed > 0
                          ? Text(
                        ' +${matchHistory.getBonus}',
                        style: textStyleMedium(
                            size: 14, color: matchHistory.getRateColor),
                      )
                          : SizedBox(),
                    ],
                  )),
              StatusIndicator(
                statusName: matchHistory.getStatusName,
                status: matchHistory.getStatus,
              ),
            ],
          ),
        ],
      ),
    );
  }
}