import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/expandable_text_widget.dart';
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
                  ? Hero(
                      tag: _groundId,
                      child: Container(
                        width: double.infinity,
                        height: UIHelper.size(200) + UIHelper.paddingTop,
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
                    top: UIHelper.size(120) + UIHelper.paddingTop),
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
              AppBarWidget(
                centerContent: Text(
                  '',
                  textAlign: TextAlign.center,
                  style: textStyleTitle(),
                ),
                leftContent: AppBarButtonWidget(
                  imageName: Images.BACK,
                  onTap: () => NavigationService.instance.goBack(),
                ),
                rightContent: AppBarButtonWidget(
                  imageName: Images.CALL,
                  onTap: () => launch('tel://${ground.phone}'),
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
                            ItemOptionWidget(
                              Images.DIRECTION,
                              ground != null ? ground.address : '',
                              iconColor: Colors.green,
                              onTap: () => launch(
                                  'https://www.google.com/maps/dir/?api=1&origin=20.986166,105.825647&destination=${ground.lat},${ground.lng}'),
                            ),
                            ItemOptionWidget(
                              Images.NOTE,
                              'Nội quy sân bóng',
                              iconColor: Colors.red,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: UIHelper.size(60)),
                              child: ExpandableTextWidget(
                                ground.rule,
                                textStyle: textStyleRegularBody(),
                              ),
                            ),
                            InkWell(
                              onTap: () => _writeReview(context,
                                  onSubmit: (rating, comment) =>
                                      model.submitReview(rating, comment)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: UIHelper.size20,
                                    vertical: UIHelper.size15),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      Images.EDIT_TEAM,
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
                                : Expanded(
                                    child: model.comments.length == 0
                                        ? Center(
                                            child: EmptyWidget(
                                                message:
                                                    'Chưa có nhận xét nào'),
                                          )
                                        : ListView.separated(
                                            padding: EdgeInsets.only(
                                                left: UIHelper.size50,
                                                right: UIHelper.size10),
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
