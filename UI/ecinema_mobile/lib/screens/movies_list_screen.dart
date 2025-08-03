import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../providers/genre_provider.dart';
import '../providers/utils.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../models/search_result.dart';
import 'movie_details_screen.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchResult<Movie>? result = null;
  bool isLoading = false;
  int currentPage = 0;
  int pageSize = 8;
  int? selectedGenreId = null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGenres();
      _loadMovies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGenres() async {
    try {
      final genreProvider = context.read<GenreProvider>();
      await genreProvider.loadGenres(reset: true);
    } catch (e) {
      print('Error loading genres: $e');
    }
  }

  Future<void> _searchMovies() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      var filter = <String, dynamic>{
        'page': 0,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'isActive': true,
      };
      
      if (_searchController.text.trim().isNotEmpty) {
        filter['title'] = _searchController.text.trim();
      }
      
      if (selectedGenreId != null) {
        filter['genreIds'] = [selectedGenreId];
      }
      
      final movieProvider = context.read<MovieProvider>();
      result = await movieProvider.get(filter: filter);
      setState(() {
        currentPage = 0;
        isLoading = false;
      });
    } catch (e) {
      print('Error searching movies: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMovies() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      final movieProvider = context.read<MovieProvider>();
      var filter = <String, dynamic>{
        'page': currentPage,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'isActive': true,
      };
      
      result = await movieProvider.get(filter: filter);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading movies: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _resetPagination() {
    setState(() {
      currentPage = 0;
    });
    _loadMovies();
  }

  void _goToNextPage() {
    if (result != null) {
      final totalCount = result!.totalCount ?? 0;
      final totalPages = (totalCount / pageSize).ceil();
      if (currentPage < totalPages) {
        setState(() {
          currentPage++;
        });
        _loadMovies();
      }
    }
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _loadMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.nowShowing),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                  _buildSearchBar(l10n, colorScheme),
                  const SizedBox(height: 16),
                  _buildGenresSection(l10n, colorScheme),
                  const SizedBox(height: 16),
                  _buildMoviesList(l10n, colorScheme),
                  if (result != null && result!.items!.isNotEmpty)
                    _buildPaginationControls(l10n, colorScheme),
                ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: l10n.searchMovies,
          hintStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 16,
          ),
          filled: true,
          fillColor: colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: colorScheme.primary,
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
        ),
        onSubmitted: (value) {
          _searchMovies();
        },
      ),
    );
  }

  Widget _buildGenresSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Consumer<GenreProvider>(
      builder: (context, genreProvider, child) {
        if (genreProvider.isLoading && genreProvider.genres.isEmpty) {
          return SizedBox(
            height: 40,
            child: Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 2,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genreProvider.genres.length + 1,
                itemBuilder: (context, index) {
                  String genreName;
                  int? genreId;
                  bool isSelected = false;
                  
                  if (index == 0) {
                    genreName = l10n.allGenres;
                    genreId = null;
                    isSelected = selectedGenreId == null;
                  } else {
                    final genre = genreProvider.genres[index - 1];
                    genreName = genre.name ?? '';
                    genreId = genre.id;
                    isSelected = selectedGenreId == genreId;
                  }
                  
                  return Container(
                    margin: EdgeInsets.only(
                      right: index < genreProvider.genres.length ? 12 : 0,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedGenreId = genreId;
                          });
                          _searchMovies();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? colorScheme.primary
                                : Theme.of(context).brightness == Brightness.dark 
                                    ? colorScheme.surfaceVariant.withOpacity(0.8)
                                    : const Color(0xFF4F8593).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected 
                                  ? colorScheme.primary
                                  : colorScheme.outline.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              genreName,
                              style: TextStyle(
                                color: isSelected 
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMoviesList(AppLocalizations l10n, ColorScheme colorScheme) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.loadingMovies,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (result == null || result!.items == null || result!.items!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noMoviesAvailable,
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      itemCount: result!.items!.length,
      itemBuilder: (context, index) {
        final movie = result!.items![index];
        return _buildMovieCard(movie, l10n, colorScheme);
      },
    );
  }

    Widget _buildMovieCard(Movie movie, AppLocalizations l10n, ColorScheme colorScheme) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 160,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: movie.image != null && movie.image!.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: imageFromString(movie.image!),
                  )
                : Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.surfaceVariant,
                          colorScheme.outline.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie, size: 40, color: colorScheme.onSurfaceVariant),
                        const SizedBox(height: 6),
                        Text(
                          l10n.noImage,
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    movie.title ?? 'Unknown Title',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  if (movie.director != null)
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          movie.director!,
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  if (movie.genres != null && movie.genres!.isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.category, size: 16, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          movie.genres!.first.name ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  if (movie.durationMinutes != null)
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${movie.durationMinutes} min',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (movie.grade != null)
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 8),
                        Text(
                          '${movie.grade!.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildPaginationControls(AppLocalizations l10n, ColorScheme colorScheme) {
    if (result == null) return const SizedBox.shrink();
    
    final totalCount = result!.totalCount ?? 0;
    final currentItems = result!.items!.length;
    final totalPages = (totalCount / pageSize).ceil();
    final hasNextPage = currentPage < totalPages;
    final hasPreviousPage = currentPage > 0;
    

    
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: hasPreviousPage 
                ? colorScheme.primaryContainer
                : colorScheme.surfaceVariant,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: hasPreviousPage ? _goToPreviousPage : null,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 16,
                        color: hasPreviousPage 
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.previous,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: hasPreviousPage 
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${currentPage + 1} / $totalPages',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$currentItems ${l10n.ofText} $totalCount',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: hasNextPage 
                ? colorScheme.primaryContainer
                : colorScheme.surfaceVariant,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: hasNextPage ? _goToNextPage : null,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.next,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: hasNextPage 
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: hasNextPage 
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 