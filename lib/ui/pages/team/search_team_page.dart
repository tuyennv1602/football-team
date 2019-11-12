import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/stringres.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/routes/routes.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet_widget.dart';
import 'package:myfootball/ui/widgets/button_widget.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/input_widget.dart';
import 'package:myfootball/ui/widgets/multichoice_position.dart';
import 'package:myfootball/ui/widgets/search_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/search_team_viewmodel.dart';
import 'package:provider/provider.dart';

enum SEARCH_TYPE { REQUEST_MEMBER, COMPARE_TEAM, SELECT_OPPONENT_TEAM }

// ignore: must_be_immutable
class SearchTeamPage extends StatelessWidget {
  String _content;
  List<String> _positions;
  final _formKey = GlobalKey<FormState>();
  final SEARCH_TYPE type;

  SearchTeamPage({Key key, this.type = SEARCH_TYPE.COMPARE_TEAM})
      : super(key: key);

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _buildItemTeam(BuildContext context, Team team) => Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIHelper.size15),
        ),
        margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
        child: InkWell(
          onTap: () {
            if (type == SEARCH_TYPE.COMPARE_TEAM) {
              Routes.routeToCompareTeam(context, team);
            } else if(type == SEARCH_TYPE.REQUEST_MEMBER) {
              _showOptions(context, team);
            } else {
              Navigator.of(context).pop(team);
            }
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: UIHelper.size10, horizontal: UIHelper.size15),
                child: ImageWidget(
                  source: team.logo,
                  placeHolder: Images.DEFAULT_LOGO,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(UIHelper.size10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(UIHelper.size15),
                      bottomRight: Radius.circular(UIHelper.size15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        team.name,
                        style: textStyleSemiBold(),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: UIHelper.size(2)),
                        child: Text(
                          'Xếp hạng: ${team.rank} (${team.point} điểm)',
                          style: textStyleRegular(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Đánh giá: ',
                            style: textStyleRegular(),
                          ),
                          RatingBarIndicator(
                            rating: team.rating,
                            itemCount: 5,
                            itemPadding: EdgeInsets.only(left: 2),
                            itemSize: UIHelper.size15,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: PRIMARY,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  void _showOptions(BuildContext context, Team team) => showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Gửi yêu cầu', 'Thông tin đội bóng', 'Huỷ'],
          onClickOption: (index) {
            if (index == 1) {
              _showRequestForm(context, team);
            }
            if (index == 2) {
              Routes.routeToOtherTeamDetail(context, team);
            }
          },
        ),
      );

  _handleSubmit(SearchTeamViewModel model, int teamId) async {
    UIHelper.showProgressDialog;
    var resp = await model.createRequest(teamId, _content, _positions);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã gửi đăng ký!');
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  void _showRequestForm(BuildContext context, Team team) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIHelper.size5),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: UIHelper.screenWidth * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(UIHelper.size10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Gửi tới: ',
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: REGULAR,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                            TextSpan(
                              text: team.name,
                              style: TextStyle(
                                fontFamily: SEMI_BOLD,
                                color: Colors.black,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: InputWidget(
                          validator: (value) {
                            if (value.isEmpty) return 'Vui lòng nhập nội dung';
                            return null;
                          },
                          onSaved: (value) => _content = value,
                          maxLines: 3,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          labelText: 'Giới thiệu bản thân',
                        ),
                      ),
                      Text(
                        'Vị trí có thể chơi (Chọn 1 hoặc nhiều)',
                        style: textStyleRegular(),
                      ),
                      MultiChoicePosition(
                        initPositions: [],
                        onChangePositions: (positions) =>
                            _positions = positions,
                      )
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ButtonWidget(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(UIHelper.size5)),
                        backgroundColor: Colors.grey,
                        height: UIHelper.size40,
                        child: Text(
                          StringRes.CANCEL,
                          style:
                              textStyleRegular(size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: BaseWidget<SearchTeamViewModel>(
                        model: SearchTeamViewModel(api: Provider.of(context)),
                        builder: (context, model, child) => ButtonWidget(
                          onTap: () {
                            if (validateAndSave()) {
                              if (_positions == null ||
                                  _positions.length == 0) {
                                UIHelper.showSimpleDialog(
                                    'Bạn chưa chọn vị trí có thể chơi');
                              } else {
                                Navigator.of(context).pop();
                                _handleSubmit(model, team.id);
                              }
                            }
                          },
                          height: UIHelper.size40,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(UIHelper.size5)),
                          child: Text(
                            'Đăng ký',
                            style:
                                textStyleRegular(size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Tìm kiếm đội bóng',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
            rightContent: type == SEARCH_TYPE.REQUEST_MEMBER
                ? AppBarButtonWidget(
                    imageName: Images.STACK,
                    onTap: () => Routes.routeToUserRequest(context),
                  )
                : AppBarButtonWidget(),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<SearchTeamViewModel>(
                model: SearchTeamViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.searchTeamByKey(''),
                child: UIHelper.homeButtonSpace,
                builder: (context, model, child) => Column(
                  children: <Widget>[
                    SearchWidget(
                      keyword: model.key,
                      hintText: 'Nhập tên đội bóng',
                      isLoading: model.isLoading,
                      onChangedText: (text) => model.searchTeamByKey(text),
                    ),
                    model.teams == null
                        ? SizedBox()
                        : Expanded(
                            child: model.teams.length == 0
                                ? EmptyWidget(message: 'Không tìm thấy kết quả')
                                : ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemCount: model.teams.length,
                                    separatorBuilder: (c, index) =>
                                        UIHelper.verticalSpaceMedium,
                                    itemBuilder: (c, index) => _buildItemTeam(
                                        context, model.teams[index]),
                                  ),
                          ),
                    child
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
