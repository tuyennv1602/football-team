import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/ui_helper.dart';

import 'button_widget.dart';
import 'input_text.dart';

typedef void OnSubmitReview(double rate, String comment);

// ignore: must_be_immutable
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
    return Material(
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                        UIHelper.size30,
                        UIHelper.paddingTop + UIHelper.size15,
                        UIHelper.size30,
                        UIHelper.size30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(UIHelper.size30),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: GREEN_GRADIENT,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          Images.EDIT_PROFILE,
                          width: UIHelper.size50,
                          height: UIHelper.size50,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: UIHelper.size30),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Đánh giá',
                                        style: textStyleRegular(
                                            color: Colors.white),
                                      ),
                                      RatingBar(
                                        initialRating: 5,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.only(
                                            right: UIHelper.size5),
                                        itemSize: UIHelper.size30,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) =>
                                            this.rating = rating,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: UIHelper.size10),
                                    child: Form(
                                      key: _formKey,
                                      child: InputText(
                                        onSaved: (value) => comment = value,
                                        maxLines: 3,
                                        maxLength: 500,
                                        inputType: TextInputType.text,
                                        inputAction: TextInputAction.done,
                                        focusedColor: Colors.white,
                                        labelText: 'Viết nhận xét',
                                        textStyle: textStyleInput(
                                            color: Colors.white),
                                        hintTextStyle: textStyleInput(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(UIHelper.size10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ButtonWidget(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          width: UIHelper.screenWidth / 3,
                          backgroundColor: GREY_BUTTON,
                          height: UIHelper.size40,
                          borderRadius: BorderRadius.circular(UIHelper.size40),
                          child: Text(
                            'HUỶ',
                            style: textStyleButton(),
                          ),
                        ),
                        ButtonWidget(
                          onTap: () {
                            Navigator.of(context).pop();
                            _onSubmitReview();
                          },
                          width: UIHelper.screenWidth / 3,
                          backgroundColor: GREEN_BUTTON,
                          margin: EdgeInsets.only(left: UIHelper.size10),
                          height: UIHelper.size40,
                          borderRadius: BorderRadius.circular(UIHelper.size40),
                          child: Text(
                            'GỬI',
                            style: textStyleButton(),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(UIHelper.size30),
                  ),
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
