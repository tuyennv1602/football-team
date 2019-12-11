import 'package:flutter/material.dart';
import 'package:myfootball/model/district.dart';
import 'package:myfootball/model/province.dart';
import 'package:myfootball/model/ward.dart';
import 'package:myfootball/resource/colors.dart';
import 'package:myfootball/resource/images.dart';
import 'package:myfootball/resource/styles.dart';
import 'package:myfootball/service/navigation_services.dart';
import 'package:myfootball/ui/page/base_widget.dart';
import 'package:myfootball/ui/widget/app_bar_button.dart';
import 'package:myfootball/ui/widget/app_bar.dart';
import 'package:myfootball/ui/widget/border_background.dart';
import 'package:myfootball/ui/widget/button_widget.dart';
import 'package:myfootball/ui/widget/line.dart';
import 'package:myfootball/ui/widget/loading.dart';
import 'package:myfootball/utils/constants.dart';
import 'package:myfootball/utils/ui_helper.dart';
import 'package:myfootball/viewmodel/add_address_viewmodel.dart';
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
                style: textStyleMediumTitle(),
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
                style: textStyleMediumTitle(),
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
          Province province, bool isSelected, Function onTap) =>
      InkWell(
        onTap: () => onTap(!isSelected, ward),
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
                  style: textStyleMediumTitle(),
                ),
              ),
              Container(
                height: UIHelper.size25,
                width: UIHelper.size25,
                margin: EdgeInsets.only(left: UIHelper.size5),
                child: Checkbox(
                    value: isSelected,
                    activeColor: PRIMARY,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (value) => onTap(value, ward)),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: BaseWidget<AddAddressViewModel>(
        model: AddAddressViewModel(sqLiteServices: Provider.of(context)),
        onModelReady: (model) {
          model.getAllProvince();
        },
        builder: (c, model, child) {
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
                          model.selectedWards.contains(model.wards[index]),
                          (isSelected, ward) {
                        if (isSelected) {
                          model.setWard(ward);
                        } else {
                          model.removeWard(ward);
                        }
                      }),
                  separatorBuilder: (c, index) => LineWidget(),
                  itemCount: model.wards.length);
              break;
          }
          bool isSelectedAll = model.wards.length == model.selectedWards.length;
          return Column(
            children: <Widget>[
              AppBarWidget(
                centerContent: Text(
                  'Thêm khu vực',
                  textAlign: TextAlign.center,
                  style: textStyleTitle(),
                ),
                leftContent: AppBarButtonWidget(
                  imageName: Images.BACK,
                  onTap: () => NavigationService.instance.goBack(),
                ),
                rightContent: model.step == Constants.SELECT_WARD
                    ? AppBarButtonWidget(
                        imageName: isSelectedAll ? Images.CLEAR : Images.CHECK,
                        onTap: () {
                          if (isSelectedAll) {
                            model.removeAllWards();
                          } else {
                            model.selectAllWards();
                          }
                        },
                      )
                    : SizedBox(),
              ),
              Expanded(
                child: BorderBackground(
                  child: model.busy
                      ? LoadingWidget()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: _child),
                            model.step == Constants.SELECT_WARD
                                ? ButtonWidget(
                                margin: EdgeInsets.symmetric(horizontal: UIHelper.padding, vertical: UIHelper.size5),
                                    backgroundColor:
                                        model.selectedWards.length > 0
                                            ? PRIMARY
                                            : Colors.grey,
                                    child: Text(
                                      'HOÀN THÀNH (${model.selectedWards.length})',
                                      style: textStyleButton(),
                                    ),
                                    onTap: () {
                                      if (model.selectedWards.length > 0) {
                                        Navigator.pop(
                                            context, model.getAddressInfo());
                                      }
                                    })
                                : SizedBox()
                          ],
                        ),
                ),
              ),
              UIHelper.homeButtonSpace
            ],
          );
        },
      ),
    );
  }
}
