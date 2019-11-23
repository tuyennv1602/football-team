import 'package:flutter/material.dart';
import 'package:myfootball/models/user_request.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/fonts.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/services/navigation_services.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/bottom_sheet.dart';
import 'package:myfootball/ui/widgets/empty_widget.dart';
import 'package:myfootball/ui/widgets/image_widget.dart';
import 'package:myfootball/ui/widgets/input_text_widget.dart';
import 'package:myfootball/ui/widgets/item_position.dart';
import 'package:myfootball/ui/widgets/light_input_text.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/ui/widgets/multichoice_position.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/user_request_viewmodel.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserRequestPage extends StatelessWidget {
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

  _showChooseAction(BuildContext context,
          {Function onEdit, Function onCancel}) =>
      showModalBottomSheet(
        context: context,
        builder: (c) => BottomSheetWidget(
          options: ['Tuỳ chọn', 'Sửa đăng ký', 'Huỷ đăng ký', 'Huỷ'],
          onClickOption: (position) async {
            if (position == 1) {
              _positions = null;
              onEdit();
            } else if (position == 2) {
              onCancel();
            }
          },
        ),
      );

  _showEditForm(
          BuildContext context, UserRequest userRequest, Function onSubmit) =>
      UIHelper.showCustomizeDialog(
        'edit_request',
        icon: Images.EDIT_PROFILE,
        confirmLabel: 'CẬP NHẬT',
        onConfirmed: () {
          if (validateAndSave()) {
            NavigationService.instance().goBack();
            onSubmit();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child: InputTextWidget(
                validator: (value) {
                  if (value.isEmpty) return 'Vui lòng nhập nội dung';
                  return null;
                },
                initValue: userRequest.content,
                onSaved: (value) => _content = value,
                maxLines: 3,
                inputType: TextInputType.text,
                inputAction: TextInputAction.done,
                labelText: 'Giới thiệu bản thân',
                textStyle: textStyleInput(color: Colors.white),
                hintTextStyle: textStyleInput(color: Colors.white),
              ),
            ),
            UIHelper.verticalSpaceSmall,
            Text(
              'Vị trí có thể chơi (Chọn 1 hoặc nhiều)',
              style: textStyleRegular(color: Colors.white),
            ),
            MultiChoicePosition(
              initPositions: userRequest.getPositions,
              onChangePositions: (positions) => _positions = positions,
            )
          ],
        ),
      );

  Widget _buildItemRequest(
      BuildContext context, UserRequestModel model, int index) {
    UserRequest request = model.userRequests[index];
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIHelper.size10),
      ),
      margin: EdgeInsets.symmetric(horizontal: UIHelper.size10),
      child: InkWell(
        onTap: () {
          if (request.status == Constants.REQUEST_REJECTED ||
              request.status == Constants.REQUEST_ACCEPTED) return;
          _showChooseAction(
            context,
            onEdit: () => _showEditForm(
              context,
              request,
              () => model.updateRequest(
                  index,
                  request.idRequest,
                  request.idTeam,
                  _content,
                  _positions != null ? _positions.join(',') : request.position),
            ),
            onCancel: () => UIHelper.showConfirmDialog(
              'Bạn có chắc chắn muốn xoá yêu cầu?',
              onConfirmed: () => model.cancelRequest(index, request.idRequest),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageWidget(
                  source: request.teamLogo, placeHolder: Images.DEFAULT_LOGO),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: UIHelper.size10),
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
                              text: request.teamName,
                              style: TextStyle(
                                fontFamily: SEMI_BOLD,
                                color: Colors.black,
                                fontSize: UIHelper.size(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        request.content,
                        style: textStyleRegular(),
                      ),
                      UIHelper.verticalSpaceSmall,
                      Row(
                          children: request.getPositions
                              .map((pos) => ItemPosition(position: pos))
                              .toList()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Ngày gửi: ${request.getCreateDate}',
                            style: textStyleRegularBody(color: Colors.grey),
                          ),
                          Text(
                            request.getStatus,
                            style: textStyleRegularBody(
                                color: request.getStatusColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UIHelper().init(context);
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Column(
        children: <Widget>[
          AppBarWidget(
            centerContent: Text(
              'Tất cả yêu cầu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => NavigationService.instance().goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<UserRequestModel>(
                onModelReady: (model) => model.getAllRequest(),
                model: UserRequestModel(api: Provider.of(context)),
                builder: (context, model, child) {
                  if (model.busy) return LoadingWidget();
                  if (model.userRequests == null ||
                      model.userRequests.length == 0)
                    return EmptyWidget(message: 'Chưa có yêu cầu nào');
                  return ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.size10),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (c, index) =>
                          _buildItemRequest(context, model, index),
                      separatorBuilder: (c, index) =>
                          UIHelper.verticalIndicator,
                      itemCount: model.userRequests.length);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
