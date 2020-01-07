import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/widget/expandable_text.dart';
import 'package:myfootball/view/widget/customize_image.dart';
import 'package:myfootball/view/ui_helper.dart';

class ItemComment extends StatelessWidget {
  final Comment comment;

  const ItemComment({Key key, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.size10, vertical: UIHelper.padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomizeImage(
            source: comment.userAvatar,
            placeHolder: Images.DEFAULT_AVATAR,
            size: UIHelper.size40,
            radius: UIHelper.size20,
            boxFit: BoxFit.cover,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: UIHelper.size10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          comment.userName,
                          style: textStyleMediumTitle(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: UIHelper.size10),
                        child: RatingBarIndicator(
                          rating: comment.rating,
                          itemCount: 5,
                          itemPadding: EdgeInsets.only(right: UIHelper.size(2)),
                          itemSize: UIHelper.size15,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    comment.getCreateTime,
                    style: textStyleRegularBody(color: Colors.grey),
                  ),
                  ExpandableText(
                    comment.comment,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
}
