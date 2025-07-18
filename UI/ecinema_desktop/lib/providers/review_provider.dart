import 'package:ecinema_desktop/models/review.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("Review");

  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }

  Future<bool> toggleSpoilerStatus(int reviewId) async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://localhost:5190/");
      final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
      final url = "$cleanBaseUrl/Review/$reviewId/toggle-spoiler";
      final uri = Uri.parse(url);
      final headers = createHeaders();

      print('Toggle spoiler URL: $url');
      print('Headers: $headers');

      final response = await http.post(uri, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (isValidResponse(response)) {
        return true;
      } else {
        throw Exception('Failed to toggle spoiler status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling spoiler status: $e');
      rethrow;
    }
  }
} 