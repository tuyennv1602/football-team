import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/comment.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/ui/widget/expandable_text_widget.dart';
import 'package:myfootball/ui/widget/image_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';

class ItemComment extends StatelessWidget {
  final Comment comment;

  const ItemComment({Key key, this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: UIHelper.size20, vertical: UIHelper.padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ImageWidget(
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
                  ExpandableTextWidget(
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
}
