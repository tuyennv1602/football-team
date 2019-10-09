import 'package:myfootball/models/province.dart';
import 'package:myfootball/viewmodels/base_viewmodel.dart';

class ProvinceViewModel extends BaseViewModel {
  final _provinces = [
    {
      "id": 7860,
      "status": 0,
      "code": "HNO",
      "name": "Hà Nội",
      "create_date": null,
      "create_user": null
    },
    {
      "id": 24181,
      "status": 0,
      "code": "HCM",
      "name": "TP. Hồ Chí Minh",
      "create_date": null,
      "create_user": null
    },
    {
      "id": 7360,
      "status": 0,
      "code": "DNA",
      "name": "Đà Nẵng",
      "create_date": null,
      "create_user": null
    },
  ];

  List<Province> provinces;

  getProvinces() {
    setBusy(true);
    provinces = new List<Province>();
    _provinces.forEach((v) {
      provinces.add(new Province.fromJson(v));
    });
    setBusy(false);
  }
}
