import '../models/user_movie_list.dart';
import '../models/search_result.dart';
import 'base_provider.dart';
import 'auth_provider.dart';

class UserMovieListProvider extends BaseProvider<UserMovieList> {
  UserMovieListProvider() : super('UserMovieList');

  @override
  UserMovieList fromJson(data) {
    return UserMovieList.fromJson(data);
  }

  Future<SearchResult<UserMovieList>> getUserMovieLists({dynamic filter}) async {
    return await get(filter: filter);
  }

  Future<void> addMovieToList(int movieId, String listType) async {
    if (AuthProvider.userId == null) {
      throw Exception('User not logged in');
    }
    
    final userMovieList = {
      'userId': AuthProvider.userId,
      'movieId': movieId,
      'listType': listType,
    };
    await insert(userMovieList);
  }

  Future<void> removeMovieFromList(int movieId, String listType) async {
    if (AuthProvider.userId == null) {
      throw Exception('User not logged in');
    }
    
    final filter = {
      'userId': AuthProvider.userId,
      'movieId': movieId,
      'listType': listType,
    };
    final lists = await get(filter: filter);
    if (lists.items != null && lists.items!.isNotEmpty) {
      await delete(lists.items!.first.id!);
    }
  }

  Future<List<UserMovieList>> getUserLists(String listType) async {
    if (AuthProvider.userId == null) {
      throw Exception('User not logged in');
    }
    
    final filter = {
      'userId': AuthProvider.userId,
      'listType': listType,
    };
    final result = await get(filter: filter);
    return result.items ?? [];
  }

  Future<bool> isMovieInList(int movieId, String listType) async {
    if (AuthProvider.userId == null) {
      throw Exception('User not logged in');
    }
    
    final filter = {
      'userId': AuthProvider.userId,
      'movieId': movieId,
      'listType': listType,
    };
    final result = await get(filter: filter);
    return result.items != null && result.items!.isNotEmpty;
  }
} 