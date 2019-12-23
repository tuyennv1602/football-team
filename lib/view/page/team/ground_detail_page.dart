import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/expandable_text_widget.dart';
import 'package:myfootball/view/widget/item_comment.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/review_dialog.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/ground_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GroundDetailPage extends StatelessWidget {
  final int _groundId;

  GroundDetailPage({@required int groundId}) : _groundId = groundId;

  _writeReview(BuildContext context, {Function onSubmit}) => showGeneralDialog(
        barrierLabel: 'review_ground',
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.6),
        transitionDuration: Duration(milliseconds: 300),
        context: context,
        pageBuilder: (context, anim1, anim2) => ReviewDialog(
          onSubmitReview: (rating, comment) => onSubmit(rating, comment),
        ),
        transitionBuilder: (context, anim1, anim2, child) => SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        ),
      );

  handleSubmitReview(
      double rating, String comment, GroundDetailViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.submitReview(rating, comment);
    UIHelper.hideProgressDialog;
    if (!resp.isSuccess) {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        builder: (c, model, child) {
          var ground = model.ground;
          return Stack(
            children: <Widget>[
              ground != null
                  ? Container(
                      width: double.infinity,
                      height: UIHelper.size(200) + UIHelper.paddingTop,
                      child: Hero(
                        tag: 'ground-$_groundId',
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.DEFAULT_GROUND,
                          image: ground.avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Image.asset(
                      Images.DEFAULT_GROUND,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: UIHelper.size(200) + UIHelper.paddingTop,
                    ),
              Container(
                margin: EdgeInsets.only(
                    top: UIHelper.size(80) + UIHelper.paddingTop),
                height: UIHelper.size(120),
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    UIHelper.size10, 0, UIHelper.size10, UIHelper.size30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: BLACK_GRADIENT,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      ground != null ? ground.name : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleSemiBold(size: 18, color: Colors.white),
                    ),
                    Text(
                      ground != null ? ground.address : '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleRegular(color: Colors.white),
                    )
                  ],
                ),
              ),
              AppBarWidget(
                centerContent: Text(
                  '',
                  textAlign: TextAlign.center,
                  style: textStyleTitle(),
                ),
                leftContent: AppBarButtonWidget(
                  imageName: Images.BACK,
                  backgroundColor: BLACK_TRANSPARENT,
                  padding: UIHelper.size10,
                  onTap: () => Navigation.instance.goBack(),
                ),
                rightContent: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AppBarButtonWidget(
                      imageName: Images.DIRECTION,
                      backgroundColor: BLACK_TRANSPARENT,
                      padding: UIHelper.size10,
                      onTap: () => launch(
                          'https://www.google.com/maps/dir/?api=1&origin=20.986166,105.825647&destination=${ground.lat},${ground.lng}'),
                    ),
                    AppBarButtonWidget(
                      imageName: Images.CALL,
                      backgroundColor: BLACK_TRANSPARENT,
                      padding: UIHelper.size10,
                      onTap: () => launch('tel://${ground.phone}'),
                    ),
                  ],
                ),
                backgroundColor: Colors.transparent,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: UIHelper.size(180) + UIHelper.paddingTop),
                child: BorderBackground(
                  child: model.busy
                      ? LoadingWidget()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(UIHelper.padding),
                              child: Text(
                                'Nội quy sân bóng',
                                style: textStyleSemiBold(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: UIHelper.size15),
                              child: ExpandableTextWidget(
                                ground.rule,
                                textStyle: textStyleRegularBody(),
                              ),
                            ),
                            InkWell(
                              onTap: () => _writeReview(
                                context,
                                onSubmit: (rating, comment) =>
                                    handleSubmitReview(rating, comment, model),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(UIHelper.padding),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Đánh giá & nhận xét',
                                        style: textStyleSemiBold(),
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
                                        color: Colors.amber,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            model.comments == null
                                ? LoadingWidget(type: LOADING_TYPE.WAVE)
                                : Expanded(
                                    child: model.comments.length == 0
                                        ? Center(
                                            child: EmptyWidget(
                                                message:
                                                    'Chưa có nhận xét nào'),
                                          )
                                        : ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (c, index) =>
                                                ItemComment(
                                                    comment:
                                                        model.comments[index]),
                                            separatorBuilder: (c, index) =>
                                                LineWidget(),
                                            itemCount: model.comments.length),
                                  )
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
