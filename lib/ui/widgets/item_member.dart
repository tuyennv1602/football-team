import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/member.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'image_widget.dart';
import 'item_position.dart';

class ItemMember extends StatelessWidget {
  final Member member;
  final bool isCaptain;
  final Function onTap;
  final bool isFullInfo;

  const ItemMember(
      {Key key,
      @required this.member,
      @required this.isCaptain,
      this.onTap,
      this.isFullInfo = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.padding),
      ),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            isCaptain
                ? Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: UIHelper.size25,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(UIHelper.padding),
                          bottomRight: Radius.circular(UIHelper.padding),
                        ),
                      ),
                      child: Text(
                        'C',
                        style: textStyleSemiBold(size: 14, color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                  child: Hero(
                    tag: member.id,
                    child: ImageWidget(
                      source: member.avatar,
                      placeHolder: Images.DEFAULT_AVATAR,
                      size: UIHelper.size50,
                      radius: UIHelper.size25,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                          itemSize: UIHelper.size(18),
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
          ],
        ),
      ),
    );
  }
}
