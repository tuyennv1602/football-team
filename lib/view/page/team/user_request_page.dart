import 'package:flutter/material.dart';
import 'package:myfootball/model/user_request.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/fonts.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/view/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/border_item.dart';
import 'package:myfootball/view/widget/bottom_sheet.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/image_widget.dart';
import 'package:myfootball/view/widget/input_text_widget.dart';
import 'package:myfootball/view/widget/item_position.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/multichoice_position.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/user_request_viewmodel.dart';
import 'package:provider/provider.dart';

class UserRequestPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  _validateAndSave() {
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
              onEdit();
            } else if (position == 2) {
              onCancel();
            }
          },
        ),
      );

  _showEditForm(
      BuildContext context, UserRequest userRequest, Function onSubmit) {
    String _content;
    List<String> _position;
    return UIHelper.showCustomizeDialog(
      'edit_request',
      icon: Images.EDIT_PROFILE,
      confirmLabel: 'CẬP NHẬT',
      onConfirmed: () {
        if (_validateAndSave()) {
          Navigation.instance.goBack();
          onSubmit(_content,
              _position != null ? _position.join(',') : userRequest.position);
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
              focusedColor: Colors.white,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              labelText: 'Giới thiệu bản thân',
              textStyle: textStyleInput(color: Colors.white),
              hintTextStyle: textStyleInput(color: Colors.white),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: UIHelper.size5),
            child: Text(
              'Vị trí có thể chơi (Chọn 1 hoặc nhiều)',
              style: textStyleRegularBody(color: Colors.white),
            ),
          ),
          MultiChoicePosition(
            initPositions: userRequest.getPositions,
            onChangePositions: (positions) => _position = positions,
          )
        ],
      ),
    );
  }

  _buildItemRequest(
      BuildContext context, UserRequestViewModel model, int index) {
    UserRequest request = model.userRequests[index];
    return BorderItemWidget(
      onTap: () {
        if (request.status == Constants.REQUEST_REJECTED ||
            request.status == Constants.REQUEST_ACCEPTED) return;
        _showChooseAction(
          context,
          onEdit: () => _showEditForm(
            context,
            request,
            (content, position) => _handleUpdate(
                index,
                UserRequest(
                    idRequest: request.idRequest,
                    idTeam: request.idTeam,
                    content: content,
                    position: position),
                model),
          ),
          onCancel: () => _handleCancel(index, request.idRequest, model),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ImageWidget(
              source: request.teamLogo, placeHolder: Images.DEFAULT_LOGO),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: UIHelper.padding),
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
                  Padding(
                    padding: EdgeInsets.only(top: UIHelper.size5),
                    child: Row(
                        children: request.getPositions
                            .map((pos) => ItemPosition(position: pos))
                            .toList()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Ngày gửi: ${request.getCreateDate}',
                        style: textStyleRegularBody(color: Colors.grey),
                      ),
                      Text(
                        request.getStatus,
                        style:
                            textStyleRegularBody(color: request.getStatusColor),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _handleUpdate(
      int index, UserRequest userRequest, UserRequestViewModel model) async {
    UIHelper.showProgressDialog;
    var resp = await model.updateRequest(index, userRequest);
    UIHelper.hideProgressDialog;
    if (resp.isSuccess) {
      UIHelper.showSimpleDialog('Đã cập nhật yêu cầu!', isSuccess: true);
    } else {
      UIHelper.showSimpleDialog(resp.errorMessage);
    }
  }

  _handleCancel(int index, int requestId, UserRequestViewModel model) {
    UIHelper.showConfirmDialog(
      'Bạn có chắc chắn muốn xoá yêu cầu?',
      onConfirmed: () async {
        UIHelper.showProgressDialog;
        var resp = await model.cancelRequest(index, requestId);
        UIHelper.hideProgressDialog;
        if (resp.isSuccess) {
          UIHelper.showSimpleDialog('Đã huỷ yêu cầu', isSuccess: true);
        } else {
          UIHelper.showSimpleDialog(resp.errorMessage);
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
          AppBarWidget(
            centerContent: Text(
              'Tất cả yêu cầu',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigation.instance.goBack(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<UserRequestViewModel>(
                onModelReady: (model) => model.getAllRequest(),
                model: UserRequestViewModel(api: Provider.of(context)),
                builder: (context, model, child) {
                  if (model.busy) return LoadingWidget();
                  if (model.userRequests == null ||
                      model.userRequests.length == 0)
                    return EmptyWidget(message: 'Chưa có yêu cầu nào');
                  return ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: UIHelper.padding),
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
