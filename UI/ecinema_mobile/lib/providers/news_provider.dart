import '../models/news.dart';
import 'base_provider.dart';

class NewsProvider extends BaseProvider<News> {
  NewsProvider() : super('NewsArticle');

  @override
  News fromJson(data) {
    return News.fromJson(data);
  }
} 