import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/invite_request.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/clipper_left_widget.dart';
import 'package:myfootball/ui/widgets/clipper_right_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/confirm_invite_viewmodel.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class ConfirmInvitePage extends StatelessWidget {
  final InviteRequest _inviteRequest;

  ConfirmInvitePage({@required InviteRequest inviteRequest})
      : _inviteRequest = inviteRequest;

  Widget _buildItemCompare(String title, String left, String right) => Padding(
        padding: EdgeInsets.symmetric(vertical: UIHelper.size5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                child: Text(left,
                    textAlign: TextAlign.left, style: textStyleRegularTitle())),
            Text(title, style: textStyleRegular()),
            Expanded(
                child: Text(right,
                    textAlign: TextAlign.right,
                    style: textStyleRegularTitle())),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    Team team = Provider.of<Team>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: BaseWidget<ConfirmInviteViewModel>(
          model: ConfirmInviteViewModel(api: Provider.of(context)),
          onModelReady: (model) =>
              model.getTeamDetail(_inviteRequest.sendGroupId),
          child: AppBarWidget(
            centerContent: SizedBox(),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
          ),
          builder: (c, model, child) {
            return Stack(
              children: <Widget>[
                Container(
                  height: UIHelper.size(210) + UIHelper.paddingTop,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Images.GROUND), fit: BoxFit.fill),
                  ),
                  child: Column(
                    children: <Widget>[
                      child,
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  ImageWidget(
                                    source: team.logo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size(70),
                                  ),
                                  Container(
                                    height: UIHelper.size(70),
                                    padding: EdgeInsets.all(UIHelper.size5),
                                    child: Text(
                                      team.name,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: textStyleSemiBold(
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(bottom: UIHelper.size(80)),
                              child: Image.asset(
                                Images.FIND_MATCH,
                                width: UIHelper.size50,
                                height: UIHelper.size50,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  ImageWidget(
                                    source: _inviteRequest.sendGroupLogo,
                                    placeHolder: Images.DEFAULT_LOGO,
                                    size: UIHelper.size(70),
                                  ),
                                  Container(
                                    height: UIHelper.size(70),
                                    padding: EdgeInsets.all(UIHelper.size5),
                                    child: Text(
                                      _inviteRequest.sendGroupName,
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: textStyleSemiBold(
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: UIHelper.size(180) + UIHelper.paddingTop),
                  child: BorderBackground(
                    child: model.busy
                        ? LoadingWidget()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: UIHelper.size10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      UIHelper.verticalSpaceSmall,
                                      _buildItemCompare('Điểm', '${team.point}',
                                          '${model.sendTeam.point}'),
                                      _buildItemCompare(
                                          'Xếp hạng',
                                          '${team.rank}',
                                          '${model.sendTeam.rank}'),
                                      _buildItemCompare('Đối đầu', '0', '0'),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIHelper.size5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            FlutterRatingBarIndicator(
                                              rating: 2.5,
                                              itemCount: 5,
                                              itemPadding:
                                                  EdgeInsets.only(left: 2),
                                              itemSize: UIHelper.size(12),
                                              emptyColor:
                                                  Colors.amber.withAlpha(90),
                                            ),
                                            Text(
                                              'Đánh giá',
                                              style: textStyleRegular(),
                                            ),
                                            FlutterRatingBarIndicator(
                                              rating: 2.5,
                                              itemCount: 5,
                                              itemPadding:
                                                  EdgeInsets.only(left: 2),
                                              itemSize: UIHelper.size(12),
                                              emptyColor:
                                                  Colors.amber.withAlpha(90),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: UIHelper.size5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              height: UIHelper.size10,
                                              width: 100,
                                              child: ClipPath(
                                                clipper: ClipperLeftWidget(),
                                                child: Container(
                                                  color: parseColor(team.dress),
                                                  child: SizedBox(),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Màu áo',
                                              style: textStyleRegular(),
                                            ),
                                            Container(
                                              height: UIHelper.size10,
                                              width: 100,
                                              child: ClipPath(
                                                clipper: ClipperRightWidget(),
                                                child: Container(
                                                  color: parseColor(
                                                      model.sendTeam.dress),
                                                  child: SizedBox(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: UIHelper.size5),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  'Xem thêm',
                                                  style: textStyleItalic(
                                                      size: 13, color: PRIMARY),
                                                ),
                                                UIHelper.horizontalSpaceSmall,
                                                Image.asset(
                                                  Images.NEXT,
                                                  width: UIHelper.size10,
                                                  height: UIHelper.size10,
                                                  color: LINE_COLOR,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: UIHelper.size5, bottom: UIHelper.size10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ButtonWidget(
                                            child: Text(
                                              'TỪ CHỐI',
                                              style: textStyleButton(),
                                            ),
                                            backgroundColor: Colors.grey,
                                            onTap: () {}),
                                      ),
                                      UIHelper.horizontalSpaceMedium,
                                      Expanded(
                                        child: ButtonWidget(
                                            child: Text(
                                              'ĐỒNG Ý',
                                              style: textStyleButton(),
                                            ),
                                            onTap: () {}),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
