import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_movie_list.dart';
import '../models/search_result.dart';
import 'base_provider.dart';
import 'auth_provider.dart';

class UserMovieListProvider extends BaseProvider<UserMovieList> {
  static const String _baseUrl = "http://10.0.2.2:5190/";
  
  int _watchlistCount = 0;
  int _watchedCount = 0;
  int _favoritesCount = 0;
  bool _isLoading = false;

  UserMovieListProvider() : super('UserMovieList');

  int get watchlistCount => _watchlistCount;
  int get watchedCount => _watchedCount;
  int get favoritesCount => _favoritesCount;
  bool get isLoading => _isLoading;

  @override
  UserMovieList fromJson(data) {
    return UserMovieList.fromJson(data);
  }

  Future<void> loadListCounts() async {
    try {
      _isLoading = true;
      notifyListeners();

      _watchlistCount = await getListCount('watchlist');
      _watchedCount = await getListCount('watched');
      _favoritesCount = await getListCount('favorites');
    } catch (e) {
      print('Error loading list counts: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SearchResult<UserMovieList>> getUserMovieLists({dynamic filter}) async {
    return await get(filter: filter);
  }

  Future<void> addMovieToList(int movieId, String listType) async {
    if (AuthProvider.userId == null) {
      throw Exception('User not logged in');
    }
    
    try {
      final response = await http.post(
        Uri.parse('${_baseUrl}UserMovieList/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}',
        },
        body: jsonEncode({
          'userId': AuthProvider.userId,
          'movieId': movieId,
          'listType': listType,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add movie to list: ${response.statusCode}');
      }
      
      await loadListCounts();
    } catch (e) {
      print('Add movie to list error: $e');
      rethrow;
    }
  }

  Future<void> removeMovieFromList(int movieId, String listType) async {
    if (AuthProvider.userId == null) {
      throw Exception('User not logged in');
    }
    
    try {
      final response = await http.delete(
        Uri.parse('${_baseUrl}UserMovieList/remove'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}',
        },
        body: jsonEncode({
          'userId': AuthProvider.userId,
          'movieId': movieId,
          'listType': listType,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove movie from list: ${response.statusCode}');
      }
      
      await loadListCounts();
    } catch (e) {
      print('Remove movie from list error: $e');
      rethrow;
    }
  }

  Future<List<UserMovieList>> getUserLists(String listType) async {
    if (AuthProvider.userId == null) {
      throw Exception('User not logged in');
    }
    
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}UserMovieList/user/${AuthProvider.userId}/list/$listType'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          final lists = data.map((item) => UserMovieList.fromJson(item)).toList();
         
          return lists;
        }
      }
      return [];
    } catch (e) {
      print('Get user lists error: $e');
      return [];
    }
  }

  Future<bool> isMovieInList(int movieId, String listType) async {
    if (AuthProvider.userId == null) {
      throw Exception('User not logged in');
    }
    
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}UserMovieList/user/${AuthProvider.userId}/movie/$movieId/list/$listType'),
        headers: {
          'Authorization': 'Basic ${base64Encode(utf8.encode('${AuthProvider.username}:${AuthProvider.password}'))}',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as bool;
      }
      return false;
    } catch (e) {
      print('Check movie in list error: $e');
      return false;
    }
  }

  Future<int> getListCount(String listType) async {
    final lists = await getUserLists(listType);
    return lists.length;
  }
}