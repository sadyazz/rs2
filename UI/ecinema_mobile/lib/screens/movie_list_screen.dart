import 'package:flutter/material.dart';
import 'package:ecinema_mobile/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/user_movie_list.dart';
import '../providers/user_movie_list_provider.dart';
import '../providers/utils.dart';
import 'movie_details_screen.dart';

class MovieListScreen extends StatefulWidget {
  final String listType;
  final String title;

  const MovieListScreen({
    super.key,
    required this.listType,
    required this.title,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<UserMovieList> _movieLists = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMovieList();
  }

  Future<void> _loadMovieList() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final provider = context.read<UserMovieListProvider>();
      final lists = await provider.getUserLists(widget.listType);
      
      setState(() {
        _movieLists = lists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeMovieFromList(int movieId, AppLocalizations l10n) async {
    try {
      final provider = context.read<UserMovieListProvider>();
      await provider.removeMovieFromList(movieId, widget.listType);
      
      setState(() {
        _movieLists.removeWhere((list) => list.movieId == movieId);
      });

      // Automatski osvježava brojeve u pozadini
      if (mounted) {
        await provider.loadListCounts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.movieRemovedFromList(widget.title.toLowerCase())),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorRemovingMovie(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showRemoveDialog(UserMovieList movieList, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.removeMovie),
          content: Text(l10n.removeMovieConfirmation(
            movieList.movie?.title ?? '', 
            widget.title.toLowerCase(),
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _removeMovieFromList(movieList.movieId!, l10n);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.remove),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMovieList,
            // tooltip: l10n.refresh,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.primary.withOpacity(0.05),
            ],
          ),
        ),
        child: _buildBody(l10n, colorScheme),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n, ColorScheme colorScheme) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.errorLoadingMovies,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMovieList,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    if (_movieLists.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getEmptyIcon(),
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessage(l10n),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptySubtitle(l10n),
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMovieList,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _movieLists.length,
        itemBuilder: (context, index) {
          final movieList = _movieLists[index];
          return _buildMovieCard(movieList, colorScheme, l10n);
        },
      ),
    );
  }

  Widget _buildMovieCard(UserMovieList movieList, ColorScheme colorScheme, AppLocalizations l10n) {
    final movie = movieList.movie;
    if (movie == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie: movie),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: movie.image != null && movie.image!.isNotEmpty
                    ? SizedBox(
                        width: 80,
                        height: 120,
                        child: imageFromString(movie.image!),
                      )
                    : Container(
                        width: 80,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.surfaceVariant,
                              colorScheme.outline.withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie,
                              color: colorScheme.onSurfaceVariant,
                              size: 32,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.noImage,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (movie.director != null) ...[
                      Text(
                        '${l10n.director}: ${movie.director}',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (movie.releaseYear != null) ...[
                      Text(
                        '${l10n.year}: ${movie.releaseYear}',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (movie.durationMinutes != null) ...[
                      Text(
                        '${l10n.duration}: ${movie.durationMinutes} ${l10n.minutes}',
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
                          IconButton(
              onPressed: () => _showRemoveDialog(movieList, l10n),
              icon: Icon(
                _getRemoveIcon(),
                color: colorScheme.error,
              ),
              tooltip: l10n.removeFromList(widget.title.toLowerCase()),
            ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getEmptyIcon() {
    switch (widget.listType.toLowerCase()) {
      case 'watchlist':
        return Icons.schedule;
      case 'favorites':
        return Icons.favorite_border;
      case 'watched':
        return Icons.check_circle_outline;
      default:
        return Icons.movie_outlined;
    }
  }

  String _getEmptyMessage(AppLocalizations l10n) {
    switch (widget.listType.toLowerCase()) {
      case 'watchlist':
        return l10n.watchlist;
      case 'favorites':
        return l10n.favorites;
      case 'watched':
        return l10n.watchedMovies;
      default:
        return widget.title;
    }
  }

  String _getEmptySubtitle(AppLocalizations l10n) {
    switch (widget.listType.toLowerCase()) {
      case 'watchlist':
        return l10n.noMoviesInWatchlist;
      case 'favorites':
        return l10n.noFavoriteMovies;
      case 'watched':
        return l10n.noWatchedMovies;
      default:
        return l10n.noMoviesInList;
    }
  }

  IconData _getRemoveIcon() {
    switch (widget.listType.toLowerCase()) {
      case 'watchlist':
        return Icons.bookmark_remove;
      case 'favorites':
        return Icons.favorite;
      case 'watched':
        return Icons.check_circle;
      default:
        return Icons.remove_circle;
    }
  }
}
