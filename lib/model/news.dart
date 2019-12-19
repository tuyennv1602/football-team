import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:myfootball/router/date_util.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:webfeed/webfeed.dart';

class News {
  RssItem rssItem;
  Document document;

  News(RssItem rssItem) {
    this.rssItem = rssItem;
    document = parse(rssItem.description);
  }

  String get getTitle => rssItem.title.trim();

  String get getImage => document.body.nodes[0].children[0].attributes['src']
      .replaceAll('180', '370');

  String get getTime =>
      timeago.format(DateUtil().parseDateRss(rssItem.pubDate), locale: 'vi');

  String get getLink => rssItem.link.trim();
}
