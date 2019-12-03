import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/member.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'image_widget.dart';

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
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                      child: Hero(
                        tag: member.id,
                        child: ImageWidget(
                          source: member.avatar,
                          placeHolder: Images.DEFAULT_AVATAR,
                          radius: UIHelper.size(55) / 2,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 3,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: UIHelper.size5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(UIHelper.size10),
                          border: Border.all(color: Colors.white)
                        ),
                        child: Text(
                          '10',
                          style: textStyleSemiBold(
                              size: 14, color: Colors.white),
                        ),
                      ),
                    )
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
          ],
        ),
      ),
    );
  }
}
