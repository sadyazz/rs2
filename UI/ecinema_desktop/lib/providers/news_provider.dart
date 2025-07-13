import 'package:ecinema_desktop/models/news.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';

class NewsProvider extends BaseProvider<News> {
  NewsProvider() : super('NewsArticle');

  @override
  News fromJson(dynamic json) {
    return News.fromJson(json);
  }
} 