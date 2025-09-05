import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';
import '../config/api_config.dart';
import 'base_provider.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super('Review');
  
  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }

  Future<bool> hasUserReviewedMovie(int movieId) async {
    try {
      var url = "${ApiConfig.baseUrl}Review/has-reviewed/$movieId";
      var uri = Uri.parse(url);
      var headers = createHeaders();

      var response = await http.get(uri, headers: headers);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return data as bool;
      }
      return false;
    } catch (e) {
      print('Error checking if user has reviewed movie: $e');
      return false;
    }
  }
} 