import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/ready_to_release_movie.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieProvider extends BaseProvider<Movie> {
  MovieProvider() : super("Movie");

  @override
  Movie fromJson(data) {
    return Movie.fromJson(data);
  }

  Future<List<ReadyToReleaseMovie>> getReadyToReleaseMovies() async {
    try {
      final headers = createHeaders();
      
      final response = await http.get(
        Uri.parse('http://localhost:5190/Movie/ready-to-release'),
        headers: headers,
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final movies = data.map((json) => ReadyToReleaseMovie.fromJson(json)).toList();
        return movies;
      }
      return [];
    } catch (e) {
      print('Error fetching ready to release movies: $e');
      return [];
    }
  }
}
