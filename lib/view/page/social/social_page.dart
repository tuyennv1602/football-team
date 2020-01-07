import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/model/match_share.dart';
import 'package:myfootball/model/news.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/customize_app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/customize_image.dart';
import 'package:myfootball/view/widget/input_text.dart';
import 'package:myfootball/view/widget/line.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/refresh_loading.dart';
import 'package:myfootball/router/paths.dart';
import 'package:myfootball/view/ui_helper.dart';
import 'package:myfootball/viewmodel/social_vm.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class SocialPage extends StatelessWidget {
  final _formCode = GlobalKey<FormState>();

  RefreshController _recruitController = RefreshController();
  RefreshController _newsController = RefreshController();

  bool validateAndSave() {
    final form = _formCode.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _buildCateTitle(String title) => Text(
        title,
        style: textStyleSemiBold(size: 18),
      );

  _buildItemNews(BuildContext context, News news) => BorderItem(
        onTap: () => launch(news.getLink),
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: InkWell(
          child: SizedBox(
            width: UIHelper.screenWidth * 0.45,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(UIHelper.padding),
                      topRight: Radius.circular(UIHelper.padding),
                    ),
                    child: SizedBox.expand(
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.DEFAULT_GROUND,
                        image: news.getImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: UIHelper.size(65),
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(UIHelper.size5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(UIHelper.padding),
                      bottomRight: Radius.circular(UIHelper.padding),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          news.getTitle,
                          maxLines: 2,
                          style: textStyleMedium(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            Images.CLOCK,
                            width: UIHelper.size10,
                            height: UIHelper.size10,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: UIHelper.size5),
                            child: Text(
                              news.getTime,
                              style:
                                  textStyleItalic(color: Colors.grey, size: 12),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  _buildItemRecruit(BuildContext context, MatchShare match,
          {Function onJoin, Function onDetail}) =>
      BorderItem(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.all(UIHelper.size10),
        onTap: () => onDetail(match.matchInfo),
        child: SizedBox(
          width: UIHelper.screenWidth * 0.45,
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CustomizeImage(
                    source: match.matchInfo.getMyTeamLogo,
                    placeHolder: Images.DEFAULT_LOGO,
                    size: UIHelper.size45,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: UIHelper.size10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            match.matchInfo.getMyTeamName,
                            style: textStyleMedium(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3),
                            child: RatingBarIndicator(
                              rating: match.matchInfo.getMyTeam.rating,
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
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: UIHelper.size10, bottom: UIHelper.size10),
                child: LineWidget(indent: 0),
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    Images.CLOCK,
                    width: UIHelper.size15,
                    height: UIHelper.size15,
                    color: Colors.deepPurpleAccent,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: UIHelper.size10),
                      child: Text(
                        match.matchInfo.getFullPlayTime,
                        style: textStyleMedium(),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: UIHelper.size5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        Images.STADIUM,
                        width: UIHelper.size15,
                        height: UIHelper.size15,
                        color: Colors.green,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: UIHelper.size10),
                          child: Text(
                            match.matchInfo.groundName,
                            style: textStyleMedium(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(UIHelper.size5),
                child: InkWell(
                  onTap: () => onJoin(match.id, match.requestCode),
                  child: Container(
                    height: UIHelper.size30,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF02DC37), PRIMARY],
                      ),
                    ),
                    child: Text(
                      'THAM GIA',
                      style: textStyleMedium(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  _showInputCode({Function onSubmit}) {
    var _code;
    UIHelper.showCustomizeDialog(
      'input_invite',
      icon: Images.INVITE,
      child: Form(
        key: _formCode,
        child: InputText(
          validator: (value) {
            if (value.isEmpty) return 'Vui lòng nhập mã trận đấu';
            return null;
          },
          onSaved: (value) => _code = value,
          maxLines: 1,
          inputType: TextInputType.text,
          inputAction: TextInputAction.done,
          labelText: 'Mã trận đấu',
          focusedColor: Colors.white,
          textStyle: textStyleMediumTitle(size: 20, color: Colors.white),
          hintTextStyle: textStyleInput(size: 20, color: Colors.white),
        ),
      ),
      onConfirmed: () {
        if (validateAndSave()) {
          Navigation.instance.goBack();
          onSubmit(_code);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          CustomizeAppBar(
            centerContent: Text(
              'Cộng đồng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<SocialViewModel>(
                model: SocialViewModel(api: Provider.of(context)),
                onModelReady: (model) {
                  model.getRanking();
                  model.getSportNews();
                  model.getMatchShares(1);
                },
                builder: (c, model, child) => ListView(
                  padding: EdgeInsets.only(top: UIHelper.padding),
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: UIHelper.padding, right: UIHelper.padding),
                      child: _buildCateTitle('Tin tức bóng đá'),
                    ),
                    SizedBox(
                      height: UIHelper.size(210),
                      child: model.isLoadingNews
                          ? LoadingWidget(type: LOADING_TYPE.WAVE)
                          : model.news == null
                              ? EmptyWidget(message: 'Có lỗi xảy ra')
                              : SmartRefresher(
                                  controller: _newsController,
                                  enablePullDown: true,
                                  header: RefreshLoading(
                                      type: REFRESH_TYPE.HORIZONTAL),
                                  onRefresh: () async {
                                    await model.getSportNews();
                                    _newsController.refreshCompleted();
                                  },
                                  child: ListView.separated(
                                    itemCount: model.news.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(UIHelper.padding),
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (c, index) => _buildItemNews(
                                        context, model.news[index]),
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            SizedBox(
                                      width: UIHelper.padding,
                                      height: 100,
                                    ),
                                  ),
                                ),
                    ),
                    LineWidget(indent: 0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: UIHelper.padding, top: UIHelper.size15),
                            child: _buildCateTitle('Tin tuyển quân'),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: UIHelper.padding, top: UIHelper.size15),
                            child: InkWell(
                              onTap: () {
                                if (model.isMatchByCode) {
                                  model.getMatchShares(1);
                                } else {
                                  _showInputCode(
                                    onSubmit: (code) =>
                                        model.getMatchSharesByCode(code),
                                  );
                                }
                              },
                              child: Text(
                                model.isMatchByCode
                                    ? 'Xem tất cả'
                                    : 'Nhập mã trận đấu',
                                textAlign: TextAlign.right,
                                style: textStyleMedium(color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: UIHelper.size(210),
                      child: model.isLoadingMatch
                          ? LoadingWidget(type: LOADING_TYPE.WAVE)
                          : model.matchShares.length == 0
                              ? EmptyWidget(message: 'Không có tin nào!')
                              : SmartRefresher(
                                  controller: _recruitController,
                                  enablePullDown: true,
                                  header: RefreshLoading(
                                      type: REFRESH_TYPE.HORIZONTAL),
                                  onRefresh: () async {
                                    await model.getMatchShares(1);
                                    _recruitController.refreshCompleted();
                                  },
                                  child: ListView.separated(
                                    itemCount: model.matchShares.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.all(UIHelper.padding),
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (c, index) =>
                                        _buildItemRecruit(
                                      context,
                                      model.matchShares[index],
                                      onJoin: (shareId, code) =>
                                          model.joinMatchByCode(shareId, code),
                                      onDetail: (matchInfo) => Navigation
                                          .instance
                                          .navigateTo(MATCH_SCHEDULE_DETAIL,
                                              arguments: matchInfo),
                                    ),
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            SizedBox(
                                      width: UIHelper.padding,
                                      height: 100,
                                    ),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
