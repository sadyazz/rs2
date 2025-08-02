import 'package:ecinema_mobile/models/genre.dart';
import 'package:ecinema_mobile/providers/base_provider.dart';

class GenreProvider extends BaseProvider<Genre> {
  List<Genre> _genres = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;

  List<Genre> get genres => _genres;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  GenreProvider() : super('Genre');

  @override
  Genre fromJson(data) {
    return Genre.fromJson(data);
  }

  Future<void> loadGenres({bool reset = false}) async {
    if (_isLoading) return;

    if (reset) {
      _genres.clear();
      _currentPage = 1;
      _hasMore = true;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await get(filter: {
        'isActive': true,
        'pageSize': 6,
        'page': _currentPage,
        'includeTotalCount': true
      });
      
      final newGenres = result.items ?? [];
      _genres.addAll(newGenres);
      
      final totalCount = result.totalCount ?? 0;
      final loadedCount = _genres.length;
      _hasMore = loadedCount < totalCount;
      
      if (_hasMore) {
        _currentPage++;
      }
    } catch (e) {
      print('Error loading genres: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}