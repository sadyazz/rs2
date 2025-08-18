import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'randomizer_screen.dart';
import 'movies_list_screen.dart';
import '../providers/genre_provider.dart';
import '../providers/movie_provider.dart';
import '../providers/utils.dart';
import '../models/movie.dart';
import '../models/search_result.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  SearchResult<Movie>? result = null;
  SearchResult<Movie>? comingSoonResult = null;
  bool isLoading = false;
  bool isLoadingComingSoon = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGenres();
      _loadMovies();
      _loadComingSoonMovies();
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

  Future<void> _loadMovies() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      final movieProvider = context.read<MovieProvider>();
      var filter = <String, dynamic>{
        'page': 0,
        'pageSize': 4,
        'includeTotalCount': true,
        'includeDeleted': false,
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

  Future<void> _loadComingSoonMovies() async {
    try {
      setState(() {
        isLoadingComingSoon = true;
      });
      
      final movieProvider = context.read<MovieProvider>();
      var filter = <String, dynamic>{
        'page': 0,
        'pageSize': 4,
        'includeTotalCount': true,
        'isComingSoon': true,
      };
      
      comingSoonResult = await movieProvider.get(filter: filter);
      setState(() {
        isLoadingComingSoon = false;
      });
    } catch (e) {
      print('Error loading coming soon movies: $e');
      setState(() {
        isLoadingComingSoon = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return SingleChildScrollView(
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              _buildSearchBar(l10n, colorScheme),
              const SizedBox(height: 16),
              _buildMovieSuggestionBanner(l10n, colorScheme),
              const SizedBox(height: 16),
              _buildNowShowingSection(l10n, colorScheme),
              _buildMoviesGrid(l10n, colorScheme),
              const SizedBox(height: 32),
              _buildComingSoonSection(l10n, colorScheme),
              _buildComingSoonMoviesGrid(l10n, colorScheme),
              const SizedBox(height: 100),
            ],
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
          suffixIcon: Icon(
            Icons.tune,
            color: colorScheme.onSurface.withOpacity(0.6),
            size: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
        ),
        onSubmitted: (value) {
          print('Search submitted: $value');
        },
      ),
    );
  }

  Widget _buildMovieSuggestionBanner(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Theme.of(context).brightness == Brightness.dark 
                ? const Color(0xFF4F8593)
                : colorScheme.primary,
            Theme.of(context).brightness == Brightness.dark 
                ? const Color(0xFF4F8593).withOpacity(0.7)
                : colorScheme.primary.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RandomizerScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.casino,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.dontKnowWhatToWatch,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.letUsSuggestMovie,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNowShowingSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.nowShowing,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MoviesListScreen(),
                  ),
                );
              },
              child: Text(
                l10n.viewAll,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildComingSoonSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.comingSoon,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildComingSoonMoviesGrid(AppLocalizations l10n, ColorScheme colorScheme) {
    if (isLoadingComingSoon) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
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

    if (comingSoonResult == null || comingSoonResult!.items == null || comingSoonResult!.items!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 64,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
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

    return GridView.builder(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: comingSoonResult!.items!.length,
      itemBuilder: (context, index) {
        final movie = comingSoonResult!.items![index];
        return _buildMovieCard(movie, l10n, colorScheme, showGrade: false);
      },
    );
  }

  Widget _buildMoviesGrid(AppLocalizations l10n, ColorScheme colorScheme) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: colorScheme.primary,
            ),
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

    return GridView.builder(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: result!.items!.length,
      itemBuilder: (context, index) {
        final movie = result!.items![index];
        return _buildMovieCard(movie, l10n, colorScheme, showGrade: true);
      },
    );
  }

  Widget _buildMovieCard(Movie movie, AppLocalizations l10n, ColorScheme colorScheme, {bool showGrade = true}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.surfaceVariant,
                          colorScheme.outline.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: movie.image != null && movie.image!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: imageFromString(movie.image!),
                          )
                        : Column(
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
                  if (movie.grade != null && showGrade)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber[600],
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 0,
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 12, color: Colors.white),
                            const SizedBox(width: 2),
                            Text(
                              movie.grade!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      movie.title ?? l10n.unknownTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      movie.director ?? l10n.unknownDirector,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.7),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (movie.genres != null && movie.genres!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: colorScheme.primary.withOpacity(0.3), width: 0.5),
                        ),
                        child: Text(
                          movie.genres!.first.name ?? l10n.unknown,
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    if (movie.durationMinutes != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time, size: 12, color: colorScheme.onSurface.withOpacity(0.6)),
                          const SizedBox(width: 3),
                          Text(
                            "${movie.durationMinutes}m",
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurface.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
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
}
