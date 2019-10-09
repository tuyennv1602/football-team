import 'package:flutter/material.dart';
import 'package:myfootball/models/district.dart';
import 'package:myfootball/models/province.dart';
import 'package:myfootball/models/ward.dart';
import 'package:myfootball/res/colors.dart';
import 'package:myfootball/res/images.dart';
import 'package:myfootball/res/styles.dart';
import 'package:myfootball/ui/pages/base_widget.dart';
import 'package:myfootball/ui/widgets/app_bar_button.dart';
import 'package:myfootball/ui/widgets/app_bar_widget.dart';
import 'package:myfootball/ui/widgets/border_background.dart';
import 'package:myfootball/ui/widgets/line.dart';
import 'package:myfootball/ui/widgets/loading.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodels/add_address_viewmodel.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatelessWidget {
  Widget _buildItemProvince(
          BuildContext context, Province province, Function onTap) =>
      InkWell(
        onTap: () => onTap(province),
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                province.name,
                maxLines: 1,
                style: textStyleRegularTitle(),
              ),
              Image.asset(
                Images.NEXT,
                width: UIHelper.size15,
                height: UIHelper.size15,
                color: Colors.grey,
              )
            ],
          ),
        ),
      );

  Widget _buildItemDistrict(BuildContext context, District district,
          Province province, Function onTap) =>
      InkWell(
        onTap: () => onTap(district),
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${district.name}, ${province.name}',
                maxLines: 1,
                style: textStyleRegularTitle(),
              ),
              Image.asset(
                Images.NEXT,
                width: UIHelper.size15,
                height: UIHelper.size15,
                color: Colors.grey,
              )
            ],
          ),
        ),
      );

  Widget _buildItemWard(BuildContext context, Ward ward, District district,
          Province province, Function onTap) =>
      InkWell(
        onTap: () => onTap(ward),
        child: Padding(
          padding: EdgeInsets.all(UIHelper.size15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  '${ward.name}, ${district.name}, ${province.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyleRegularTitle(),
                ),
              ),
              UIHelper.horizontalSpaceSmall,
              Image.asset(
                Images.CHECK,
                width: UIHelper.size15,
                height: UIHelper.size15,
                color: Colors.green,
              )
            ],
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
              'Thêm khu vực',
              textAlign: TextAlign.center,
              style: textStyleTitle(),
            ),
            leftContent: AppBarButtonWidget(
              imageName: Images.BACK,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Expanded(
            child: BorderBackground(
              child: BaseWidget<AddAddressViewModel>(
                model: AddAddressViewModel(api: Provider.of(context)),
                onModelReady: (model) {
                  model.getAllProvince();
                },
                builder: (c, model, child) {
                  if (model.busy) {
                    return LoadingWidget();
                  }
                  Widget _child;
                  switch (model.step) {
                    case Constants.SELECT_PROVINCE:
                      _child = ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (c, index) => _buildItemProvince(
                              context,
                              model.provinces[index],
                              (province) => model.setProvince(province)),
                          separatorBuilder: (c, index) => LineWidget(),
                          itemCount: model.provinces.length);
                      break;
                    case Constants.SELECT_DISTRICT:
                      _child = ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (c, index) => _buildItemDistrict(
                              context,
                              model.districts[index],
                              model.province,
                              (district) => model.setDistrict(district)),
                          separatorBuilder: (c, index) => LineWidget(),
                          itemCount: model.districts.length);
                      break;
                    case Constants.SELECT_WARD:
                      _child = ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (c, index) => _buildItemWard(
                              context,
                              model.wards[index],
                              model.district,
                              model.province,
                              (ward) {
                                model.setWard(ward);
                                Navigator.pop(context, model.getAddressInfo());
                              }),
                          separatorBuilder: (c, index) => LineWidget(),
                          itemCount: model.wards.length);
                      break;
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[Expanded(child: _child)],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
