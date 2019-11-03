import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfootball/models/team.dart';
import 'package:myfootball/res/colors.dart';
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
import 'package:myfootball/ui/widgets/input_widget.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/multichoice_position.dart';
import 'package:myfootball/ui/widgets/search_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/request_member_viewmodel.dart';
import 'package:provider/provider.dart';

class RequestMemberPage extends StatelessWidget {
  String _content;
  List<String> _positions;
  final _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

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

  Widget _buildItemTeam(BuildContext context, Team team) => InkWell(
        onTap: () => _showOptions(context, team),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: UIHelper.size15, vertical: UIHelper.size10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ImageWidget(
                source: team.logo,
                placeHolder: Images.DEFAULT_LOGO,
              ),
              UIHelper.horizontalSpaceMedium,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      team.name,
                      style: textStyleSemiBold(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size(2)),
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
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  _handleSubmit(RequestMemberViewModel model, int teamId) async {
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
                      Text(
                        'Gửi tới: ${team.name}',
                        style: textStyleRegularTitle(),
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
                        style: textStyleRegular(color: Colors.grey),
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
                      child: BaseWidget<RequestMemberViewModel>(
                        model:
                            RequestMemberViewModel(api: Provider.of(context)),
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
            rightContent: AppBarButtonWidget(
              imageName: Images.STACK,
              onTap: () => Routes.routeToUserRequest(context),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<RequestMemberViewModel>(
                model: RequestMemberViewModel(api: Provider.of(context)),
                onModelReady: (model) => model.searchTeamByKey(''),
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
                                        LineWidget(),
                                    itemBuilder: (c, index) => _buildItemTeam(
                                        context, model.teams[index]),
                                  ),
                          ),
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
