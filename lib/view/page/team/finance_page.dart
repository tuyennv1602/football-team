import 'dart:core';

import 'package:flutter/material.dart';
import 'package:myfootball/model/team.dart';
import 'package:myfootball/model/user.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/router/navigation.dart';
import 'package:myfootball/view/page/base_widget.dart';
import 'package:myfootball/view/widget/app_bar_button.dart';
import 'package:myfootball/view/widget/app_bar.dart';
import 'package:myfootball/view/widget/border_background.dart';
import 'package:myfootball/view/widget/choose_transaction_type.dart';
import 'package:myfootball/view/widget/empty_widget.dart';
import 'package:myfootball/view/widget/input_price_widget.dart';
import 'package:myfootball/view/widget/input_text_widget.dart';
import 'package:myfootball/view/widget/item_transaction.dart';
import 'package:myfootball/view/widget/loading.dart';
import 'package:myfootball/view/widget/refresh_loading.dart';
import 'package:myfootball/view/widget/select_date.dart';
import 'package:myfootball/utils/router_paths.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/finance_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

// ignore: must_be_immutable
class FinancePage extends StatelessWidget {
  final _formTransactionKey = GlobalKey<FormState>();
  final _formNotifyKey = GlobalKey<FormState>();
  FinanceViewModel _viewModel;
  RefreshController _transactionController = RefreshController();

  bool validateAndSaveNotification() {
    final form = _formNotifyKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool validateAndSaveTransaction() {
    final form = _formTransactionKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _createFundNotification(BuildContext context, {Function onSubmit}) {
    var _price;
    var _expireDate;
    var _title;
    return UIHelper.showCustomizeDialog(
      'create noti',
      icon: Images.FUND_NOTIFY,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Số tiền cần thu',
            style: textStyleRegularBody(color: Colors.white),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: UIHelper.size5, bottom: UIHelper.size10),
            child: InputPriceWidget(
                textStyle: textStyleSemiBold(size: 18, color: Colors.white),
                hint: '0đ',
                hintTextStyle: textStyleSemiBold(size: 18, color: Colors.white),
                onChangedText: (text) => _price = text),
          ),
          Text(
            'Chọn hạn thu quỹ',
            style: textStyleRegularBody(color: Colors.white),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: UIHelper.size5, bottom: UIHelper.size10),
            child: SelectDateWidget(
              textStyle: textStyleSemiBold(size: 18, color: Colors.white),
              onSelectedDate: (date) => _expireDate = date,
            ),
          ),
          Form(
            key: _formNotifyKey,
            child: InputTextWidget(
              validator: (value) {
                if (value.isEmpty) return 'Vui lòng nhập tiêu đề';
                return null;
              },
              onSaved: (value) => _title = value,
              maxLines: 1,
              focusedColor: Colors.white,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              labelText: 'Tiêu đề',
              textStyle: textStyleInput(color: Colors.white),
              hintTextStyle: textStyleInput(color: Colors.white),
            ),
          ),
        ],
      ),
      onConfirmed: () {
        if (validateAndSaveNotification()) {
          Navigation.instance.goBack();
          onSubmit(_title, _price, _expireDate);
        }
      },
    );
  }

  _createTransaction(BuildContext context, {Function onSubmit}) {
    var _transaction;
    var _price;
    var _type;
    return UIHelper.showCustomizeDialog(
      'create_transaction',
      icon: Images.EDIT_PROFILE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Số tiền giao dịch',
            style: textStyleRegularBody(color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(top: UIHelper.size5),
            child: InputPriceWidget(
                textStyle: textStyleSemiBold(size: 18, color: Colors.white),
                hint: '0đ',
                hintTextStyle: textStyleSemiBold(size: 18, color: Colors.white),
                onChangedText: (text) => _price = text),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: UIHelper.size5, bottom: UIHelper.size20),
            child: ChooseTransactionWidget(
                onSelectedType: (type) => _type = type),
          ),
          Form(
            key: _formTransactionKey,
            child: InputTextWidget(
              validator: (value) {
                if (value.isEmpty) return 'Vui lòng nhập nội dung';
                return null;
              },
              onSaved: (value) => _transaction = value,
              maxLines: 1,
              focusedColor: Colors.white,
              inputType: TextInputType.text,
              inputAction: TextInputAction.done,
              labelText: 'Nôi dung giao dịch',
              textStyle: textStyleInput(color: Colors.white),
              hintTextStyle: textStyleInput(color: Colors.white),
            ),
          ),
        ],
      ),
      onConfirmed: () {
        if (validateAndSaveTransaction()) {
          Navigation.instance.goBack();
          onSubmit(_price, _type, _transaction);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var team = Provider.of<Team>(context);
    bool isManager = team.hasManager(Provider.of<User>(context).id);
    return Scaffold(
      backgroundColor: PRIMARY,
      resizeToAvoidBottomPadding: false,
      floatingActionButton: isManager
          ? UnicornDialer(
              parentButtonBackground: PRIMARY,
              orientation: UnicornOrientation.VERTICAL,
              hasBackground: true,
              backgroundColor: BLACK_TRANSPARENT,
              parentButton: Icon(Icons.add),
              childButtons: [
                UnicornButton(
                  labelText: 'Tạo thông báo',
                  hasLabel: true,
                  labelBackgroundColor: Colors.white,
                  labelColor: Colors.black,
                  currentButton: FloatingActionButton(
                    heroTag: 'a',
                    backgroundColor: PRIMARY,
                    mini: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        Images.FUND_NOTIFY,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _createFundNotification(
                      context,
                      onSubmit: (title, price, expiredDate) => _viewModel
                          .createFundNotify(title, price, expiredDate),
                    ),
                  ),
                ),
                UnicornButton(
                  labelText: 'Tạo giao dịch',
                  hasLabel: true,
                  labelBackgroundColor: Colors.white,
                  labelColor: Colors.black,
                  currentButton: FloatingActionButton(
                    heroTag: 'b',
                    backgroundColor: PRIMARY,
                    mini: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        Images.TRANSACTIONS,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => _createTransaction(context,
                        onSubmit: (price, type, title) =>
                            _viewModel.createExchange(price, type, title)),
                  ),
                )
              ],
            )
          : SizedBox(),
      body: BaseWidget<FinanceViewModel>(
        model: FinanceViewModel(api: Provider.of(context), teamId: team.id),
        onModelReady: (model) {
          _viewModel = model;
          model.getTransactions(false);
        },
        builder: (c, model, child) => Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: UIHelper.size(150) + UIHelper.paddingTop,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(
                  bottom: UIHelper.size30,
                  left: UIHelper.size15,
                  right: UIHelper.size15),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/wallet_bg.jpg'),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Đã thu',
                        style: textStyleTitle(),
                      ),
                      Expanded(
                        child: Text(
                          model.income,
                          style: textStyleTitle(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: UIHelper.size10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Đã chi',
                          style: textStyleTitle(),
                        ),
                        Expanded(
                          child: Text(
                            model.outcome,
                            textAlign: TextAlign.right,
                            style: textStyleTitle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppBarWidget(
              centerContent: InkWell(
                onTap: () async {
                  var date = await showMonthPicker(
                      context: context, initialDate: DateTime.now());
                  if (date != null) {
                    model.changeMonth(date);
                  }
                },
                child: Center(
                  child: Text(
                    'Th ${model.getCurrentMonth}',
                    style: textStyleTitle(),
                  ),
                ),
              ),
              leftContent: AppBarButtonWidget(
                imageName: Images.BACK,
                onTap: () => Navigation.instance.goBack(),
              ),
              backgroundColor: Colors.transparent,
              rightContent: AppBarButtonWidget(
                imageName: Images.BUDGET,
                onTap: () => Navigation.instance.navigateTo(TEAM_FUND),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: UIHelper.size(130) + UIHelper.paddingTop),
              child: BorderBackground(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: model.busy
                          ? LoadingWidget()
                          : model.transactions.length == 0
                              ? EmptyWidget(message: 'Chưa có giao dịch nào')
                              : SmartRefresher(
                                  controller: _transactionController,
                                  enablePullDown: true,
                                  header: RefreshLoading(),
                                  onRefresh: () async {
                                    await model.getTransactions(true);
                                    _transactionController.refreshCompleted();
                                  },
                                  child: ListView.separated(
                                      padding: EdgeInsets.symmetric(
                                          vertical: UIHelper.padding),
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (c, index) =>
                                          ItemTransactionWidget(
                                            transaction:
                                                model.transactions[index],
                                          ),
                                      separatorBuilder: (c, index) =>
                                          UIHelper.verticalIndicator,
                                      itemCount: model.transactions.length),
                                ),
                    ),
                    UIHelper.homeButtonSpace
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
