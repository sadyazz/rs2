import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_provider.dart';
import '../models/movie.dart';
import '../config/api_config.dart';

class MovieProvider extends BaseProvider<Movie> {
  MovieProvider() : super("Movie");

  @override
  Movie fromJson(data) {
    return Movie.fromJson(data);
  }

  Future<dynamic> getRecommendation({
    String genre = "all",
    String duration = "90",
    double minRating = 0,
  }) async {
    var baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:5190/");
    var url = "$baseUrl${"Movie/recommendation"}";
    
    var queryParams = <String, String>{};

    if (genre != "all") {
      queryParams['genreName'] = genre;
    }

    if (duration != "any") {
      var maxDuration = int.parse(duration);
      queryParams['maxDuration'] = maxDuration.toString();
    }

    if (minRating >= 1.0) {
      queryParams['minRating'] = minRating.toInt().toString();
    } else {
      print('MovieProvider - minRating not added to query params (minRating < 1.0)');
    }
    
    queryParams['debugMinRating'] = minRating.toString();

    var uri = Uri.parse(url).replace(queryParameters: queryParams);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      if (response.body.isEmpty || response.body == 'null') {
        return null;
      }
      var data = jsonDecode(response.body);
      if (data == null) {
        return null;
      }
      return fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<List<Movie>> getRecommendedMovies(int userId, {int numberOfRecommendations = 4}) async {
    var url = "${ApiConfig.baseUrl}User/$userId/recommended-movies?numberOfRecommendations=$numberOfRecommendations";
    var headers = createHeaders();

    try {
      var response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Movie.fromJson(item)).toList();
      } else {
        throw Exception('Error loading recommended movies, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
      rethrow;
    }
  }
} 