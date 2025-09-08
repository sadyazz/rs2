import '../models/news.dart';
import 'base_provider.dart';

class NewsProvider extends BaseProvider<News> {
  NewsProvider() : super('NewsArticle');

  @override
  News fromJson(data) {
    try {
      return News.fromJson(data);
    } catch (e) {
      print('Error parsing news: $e');
      rethrow;
    }
  }
} 
