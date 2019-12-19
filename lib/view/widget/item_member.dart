import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'image_widget.dart';

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
    return BorderItemWidget(
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
                    width: UIHelper.size25,
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
                        tag: 'member - ${member.id}',
                        child: ImageWidget(
                          source: member.avatar,
                          placeHolder: Images.DEFAULT_AVATAR,
                          radius: UIHelper.size(55) / 2,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    member.number != null
                        ? Positioned(
                            bottom: 3,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIHelper.size5),
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
                                style: textStyleSemiBold(
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        member.name,
                        style: textStyleSemiBold(size: 15),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
                        child: RatingBarIndicator(
                          rating: member.getRating,
                          itemCount: 5,
                          itemPadding: EdgeInsets.only(right: 2),
                          itemSize: UIHelper.size15,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: UIHelper.size10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(UIHelper.padding),
                      bottomLeft: Radius.circular(UIHelper.padding),
                    ),
                    child: Row(
                      children: member.getPositions
                          .map<Widget>(
                            (pos) => Expanded(
                              child: Container(
                                color: getPositionColor(pos),
                              ),
                            ),
                          )
                          .toList(),
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
