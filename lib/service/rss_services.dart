import 'package:webfeed/webfeed.dart';
import 'package:dio/dio.dart';
import '../http.dart';

class RssServices {
  Future<List<RssItem>> getSportNews() async {
    try {
      var response = await dio
          .get('https://thethao.thanhnien.vn/rss/bong-da-viet-nam.rss');
      var rss = RssFeed.parse(response.data);
      return rss.items;
    } on DioError catch (_) {
      return null;
    }
  }
}
