import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/comment.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/item_comment.dart';
import 'package:myfootball/ui/widgets/item_option.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/review_dialog.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/ground_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GroundDetailPage extends StatelessWidget {
  final int _groundId;

  GroundDetailPage({@required int groundId}) : _groundId = groundId;

  _writeReview(BuildContext context, GroundDetailViewModel model) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIHelper.size5),
          ),
          contentPadding: EdgeInsets.zero,
          content: ReviewDialog(
            onSubmitReview: (rating, comment) async {
              UIHelper.showProgressDialog;
              var resp = await model.submitReview(rating, comment);
              UIHelper.hideProgressDialog;
              if (!resp.isSuccess) {
                UIHelper.showSimpleDialog(resp.errorMessage);
              }
            },
          ),
        ),
      );

  Widget _buildItemComment(BuildContext context, Comment comment) => Padding(
        padding: EdgeInsets.all(UIHelper.size10),
        child: Text(comment.comment),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: false,
      body: BaseWidget<GroundDetailViewModel>(
        model: GroundDetailViewModel(
            api: Provider.of(context), groundId: _groundId),
        onModelReady: (model) {
          model.getGroundDetail();
          model.getComments();
        },
        child: AppBarWidget(
          centerContent: Text(
            '',
            textAlign: TextAlign.center,
            style: textStyleTitle(),
          ),
          leftContent: AppBarButtonWidget(
            imageName: Images.BACK,
            onTap: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
        ),
        builder: (c, model, child) {
          var ground = model.ground;
          return Stack(
            children: <Widget>[
              ground != null
                  ? Container(
                      width: double.infinity,
                      height: UIHelper.size(220) + UIHelper.paddingTop,
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.DEFAULT_GROUND,
                        image: ground.avatar,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      Images.DEFAULT_GROUND,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: UIHelper.size(220) + UIHelper.paddingTop,
                    ),
              Container(
                margin: EdgeInsets.only(
                    top: UIHelper.size(140) + UIHelper.paddingTop),
                height: UIHelper.size(80),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: UIHelper.size10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: BLACK_GRADIENT,
                  ),
                ),
                child: Text(
                  ground != null ? ground.name : '',
                  maxLines: 1,
                  style: textStyleSemiBold(size: 18, color: Colors.white),
                ),
              ),
              child,
              Container(
                margin: EdgeInsets.only(
                    top: UIHelper.size(200) + UIHelper.paddingTop),
                child: BorderBackground(
                  child: model.busy
                      ? LoadingWidget()
                      : ListView(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          children: <Widget>[
                            ItemOptionWidget(
                              Images.DIRECTION,
                              ground != null ? ground.address : '',
                              iconColor: Colors.green,
                              onTap: () => launch(
                                  'https://www.google.com/maps/dir/?api=1&origin=20.986166,105.825647&destination=${ground.lat},${ground.lng}'),
                            ),
                            LineWidget(),
                            ItemOptionWidget(
                              Images.PHONE,
                              ground != null ? ground.phone : '',
                              iconColor: Colors.blueAccent,
                              onTap: () => launch('tel://${ground.phone}'),
                            ),
                            LineWidget(),
                            ItemOptionWidget(
                              Images.NOTE,
                              'Nội quy sân bóng',
                              iconColor: Colors.red,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: UIHelper.size(60)),
                              child: Text(
                                ground.rule,
                                style: textStyleRegularBody(),
                              ),
                            ),
                            UIHelper.verticalSpaceSmall,
                            LineWidget(),
                            InkWell(
                              onTap: () => _writeReview(context, model),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: UIHelper.size20,
                                    vertical: UIHelper.size15),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      Images.EDIT_PROFILE,
                                      width: UIHelper.size20,
                                      height: UIHelper.size20,
                                      color: Colors.amber,
                                    ),
                                    UIHelper.horizontalSpaceLarge,
                                    Expanded(
                                      child: Text(
                                        'Đánh giá & nhận xét',
                                        style: textStyleRegularTitle(),
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      rating: ground.rating,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.only(
                                          right: UIHelper.size(2)),
                                      itemSize: UIHelper.size20,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: PRIMARY,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            model.comments == null
                                ? LoadingWidget(type: LOADING_TYPE.WAVE)
                                : model.comments.length == 0
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            top: UIHelper.size20),
                                        child: EmptyWidget(
                                            message: 'Chưa có nhận xét nào'),
                                      )
                                    : ListView.separated(
                                        padding: EdgeInsets.only(
                                            left: UIHelper.size50,
                                            right: UIHelper.size10),
                                        itemBuilder: (c, index) => ItemComment(
                                            comment: model.comments[index]),
                                        separatorBuilder: (c, index) =>
                                            LineWidget(),
                                        itemCount: model.comments.length)
                          ],
                        ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
