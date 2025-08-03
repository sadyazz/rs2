import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_provider.dart';
import '../models/movie.dart';

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

    // Add genre filter if not "all"
    if (genre != "all") {
      queryParams['genreName'] = genre;
    }

    // Add duration filter
    if (duration != "any") {
      var maxDuration = int.parse(duration);
      queryParams['maxDuration'] = maxDuration.toString();
    }

    // Add rating filter
    if (minRating > 0) {
      queryParams['minRating'] = minRating.toString();
    }

    var uri = Uri.parse(url).replace(queryParameters: queryParams);
    var headers = createHeaders();

    print('MovieProvider - URL: $uri');
    print('MovieProvider - Query params: $queryParams');

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw new Exception("No movies found matching the criteria");
    }
  }
} 