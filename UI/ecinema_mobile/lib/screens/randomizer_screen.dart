import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../layouts/master_screen.dart';
import '../providers/movie_provider.dart';
import '../providers/genre_provider.dart';
import '../providers/utils.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import 'package:provider/provider.dart';
import 'movie_details_screen.dart';

class RandomizerScreen extends StatefulWidget {
  const RandomizerScreen({super.key});

  @override
  State<RandomizerScreen> createState() => _RandomizerScreenState();
}

class _RandomizerScreenState extends State<RandomizerScreen> {
  bool _isLoading = false;
  String? _selectedMovie;
  Movie? _selectedMovieData;
  final ScrollController _scrollController = ScrollController();
  
  String _selectedGenre = 'all';
  String _selectedDuration = '90';
  double _selectedRating = 4.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGenres();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return MasterScreen(
      "",
      SingleChildScrollView(
        controller: _scrollController,
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
              children: [
                _buildFilterSection(l10n, colorScheme),
                const SizedBox(height: 32),
                _buildActionButtons(l10n, colorScheme),
                const SizedBox(height: 32),
                _buildResult(l10n, colorScheme),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      showBottomNav: false,
      showBackButton: true,
    );
  }

  Widget _buildFilterSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.filterBy,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildGenreFilter(l10n, colorScheme),
        const SizedBox(height: 24),
        _buildDurationFilter(l10n, colorScheme),
        const SizedBox(height: 24),
        _buildRatingFilter(l10n, colorScheme),
      ],
    );
  }

  Widget _buildGenreFilter(AppLocalizations l10n, ColorScheme colorScheme) {
    final genreProvider = context.watch<GenreProvider>();
    
    final allGenresOption = Genre(id: -1, name: l10n.allGenres);
    final allGenres = [allGenresOption, ...genreProvider.genres];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.genre,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        genreProvider.isLoading && genreProvider.genres.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              )
            : Column(
                                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...allGenres.map((genre) {
                        final isSelected = _selectedGenre == (genre.id == -1 ? 'all' : genre.name);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedGenre = genre.id == -1 ? 'all' : genre.name ?? '';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF4F8593) : colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF4F8593) : colorScheme.outline.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              genre.name ?? '',
                              style: TextStyle(
                                color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      if (genreProvider.hasMore && !genreProvider.isLoading)
                        GestureDetector(
                          onTap: () {
                            genreProvider.loadGenres();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: colorScheme.outline.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.expand_more,
                                  color: colorScheme.onSurfaceVariant,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Load More',
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (genreProvider.isLoading && genreProvider.genres.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ],
    );
  }

  Widget _buildDurationFilter(AppLocalizations l10n, ColorScheme colorScheme) {
    final durationOptions = [
      {'key': '60', 'label': l10n.upTo60Minutes},
      {'key': '90', 'label': l10n.upTo90Minutes},
      {'key': '120', 'label': l10n.upTo120Minutes},
      {'key': '150', 'label': l10n.upTo150Minutes},
      {'key': '180', 'label': l10n.upTo180Minutes},
      {'key': 'any', 'label': l10n.anyDuration},
    ];

    final selectedOption = durationOptions.firstWhere(
      (option) => option['key'] == _selectedDuration,
      orElse: () => durationOptions[1],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.duration,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            _showDurationDialog(context, l10n, colorScheme, durationOptions);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedOption['label']!,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDurationDialog(BuildContext context, AppLocalizations l10n, ColorScheme colorScheme, List<Map<String, String>> options) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.duration),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = _selectedDuration == option['key'];
            return ListTile(
              title: Text(option['label']!),
              leading: isSelected ? Icon(Icons.check, color: colorScheme.primary) : null,
              onTap: () {
                setState(() {
                  _selectedDuration = option['key']!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingFilter(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.minimumRating,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ...List.generate(5, (index) {
              final starValue = index + 1.0;
              final isSelected = _selectedRating >= starValue;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = starValue;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Icon(
                    isSelected ? Icons.star : Icons.star_border,
                    color: isSelected ? Colors.amber : colorScheme.onSurfaceVariant,
                    size: 32,
                  ),
                ),
              );
            }),
            const SizedBox(width: 16),
            Text(
              '${_selectedRating.toStringAsFixed(1)} +',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _generateRandomMovie,
            icon: Icon(
              Icons.casino,
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              l10n.suggestMovie,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F8593),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _resetFilters,
            icon: Icon(
              Icons.refresh,
              color: colorScheme.onSurface,
              size: 20,
            ),
            label: Text(
              l10n.reset,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.surfaceVariant,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResult(AppLocalizations l10n, ColorScheme colorScheme) {
    if (_selectedMovie == null) {
      return Container(
        height: 300,
        child: Center(
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
                'Click the button above to get a random movie suggestion!',
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_selectedMovieData != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailsScreen(movie: _selectedMovieData!),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _selectedMovieData!.image != null && _selectedMovieData!.image!.isNotEmpty
                      ? imageFromString(_selectedMovieData!.image!)
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.movie,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _selectedMovie!,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_selectedMovieData != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      _selectedMovieData!.genres?.isNotEmpty == true
                          ? _selectedMovieData!.genres!.first.name ?? 'Unknown'
                          : 'Unknown',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      '${_selectedMovieData!.durationMinutes} min',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_selectedMovieData!.grade != null && _selectedMovieData!.grade! > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        '${_selectedMovieData!.grade!.toStringAsFixed(1)}/5',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (_selectedMovieData!.description != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedMovieData!.description!,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.8),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 16,
                    color: colorScheme.primary.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.tapToViewDetails,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateRandomMovie() async {
    if (!mounted) return;
    
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isLoading = true;
    });

    try {
      final movieProvider = context.read<MovieProvider>();
      final recommendation = await movieProvider.getRecommendation(
        genre: _selectedGenre == 'all' ? 'all' : _selectedGenre,
        duration: _selectedDuration,
        minRating: _selectedRating,
      );

      if (!mounted) return;

      setState(() {
        if (recommendation == null) {
          _selectedMovie = null;
          _selectedMovieData = null;
        } else {
          _selectedMovieData = recommendation;
          _selectedMovie = recommendation.title ?? 'Unknown Movie';
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
              );
            }
          });
        }
        _isLoading = false;
      });

      if (recommendation == null && mounted) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.noMoviesFound),
            content: Text(l10n.noMoviesFoundMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
      });
      
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(l10n.noMoviesFound),
          content: Text(l10n.noMoviesFoundMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedGenre = 'all';
      _selectedDuration = '90';
      _selectedRating = 4.0;
      _selectedMovie = null;
      _selectedMovieData = null;
    });
  }
} 