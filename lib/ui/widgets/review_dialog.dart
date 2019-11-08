import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/utils/ui_helper.dart';

import 'button_widget.dart';
import 'input_widget.dart';

typedef void OnSubmitReview(double rate, String comment);

class ReviewDialog extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  String comment;
  double rating = 5;
  final OnSubmitReview onSubmitReview;

  ReviewDialog({Key key, @required this.onSubmitReview}) : super(key: key);

  _onSubmitReview() {
    _formKey.currentState.save();
    onSubmitReview(this.rating, this.comment);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: UIHelper.screenWidth * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
                UIHelper.size15, UIHelper.size15, UIHelper.size15, 0),
            child: Column(
              children: <Widget>[
                Text(
                  'Đánh giá & nhận xét',
                  style: textStyleBold(),
                ),
                UIHelper.verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Đánh giá',
                      style: textStyleRegular(),
                    ),
                    RatingBar(
                      initialRating: 5,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: EdgeInsets.only(right: UIHelper.size5),
                      itemSize: UIHelper.size30,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) => this.rating = rating,
                    ),
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Form(
                  key: _formKey,
                  child: InputWidget(
                    onSaved: (value) => comment = value,
                    maxLines: 3,
                    maxLength: 500,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    labelText: 'Viết nhận xét',
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonWidget(
                  onTap: () => Navigator.of(context).pop(),
                  height: UIHelper.size40,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(UIHelper.size5)),
                  backgroundColor: Colors.grey,
                  child: Text(
                    'Huỷ',
                    style: textStyleRegular(size: 16, color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: ButtonWidget(
                  onTap: () {
                    Navigator.of(context).pop();
                    _onSubmitReview();
                  },
                  height: UIHelper.size40,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(UIHelper.size5)),
                  child: Text(
                    'Gửi',
                    style: textStyleRegular(size: 16, color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
