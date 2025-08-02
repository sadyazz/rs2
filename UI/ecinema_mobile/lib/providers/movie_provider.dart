import 'base_provider.dart';

class MovieProvider extends BaseProvider<dynamic> {
  MovieProvider() : super("Movie");

  @override
  dynamic fromJson(data) {
    return data;
  }
} 