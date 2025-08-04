import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/review.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/actor_provider.dart';
import 'package:ecinema_desktop/providers/genre_provider.dart';
import 'package:ecinema_desktop/providers/movie_provider.dart';
import 'package:ecinema_desktop/providers/review_provider.dart';
import 'package:ecinema_desktop/providers/utils.dart';
import 'package:ecinema_desktop/screens/reviews_screen.dart';
import 'package:ecinema_desktop/screens/edit_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieProvider? movieProvider;
  ReviewProvider? reviewProvider;
  GenreProvider? genreProvider;   
  ActorProvider? actorProvider;
  Movie? detailedMovie;
  SearchResult<Review>? reviewsResult;
  bool isLoading = false;
  bool isLoadingReviews = false;
  bool isLoadingGenres = false;
  bool isLoadingActors = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    movieProvider = context.read<MovieProvider>();
    reviewProvider = context.read<ReviewProvider>();
    genreProvider = context.read<GenreProvider>();
    actorProvider = context.read<ActorProvider>();
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.movie.id != null) {
        _loadMovieDetails();
        _loadReviews();
        _loadGenres();
        _loadActors();
      } else {
        detailedMovie = widget.movie;
      }
    });
  }

  Future<void> _loadMovieDetails() async {
    if (widget.movie.id == null || movieProvider == null) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      final movie = await movieProvider!.getById(widget.movie.id!);
      setState(() {
        detailedMovie = movie ?? widget.movie;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading movie details: $e');
      setState(() {
        detailedMovie = widget.movie;
        isLoading = false;
      });
    }
  }

  Future<void> _loadReviews() async {
    if (widget.movie.id == null || reviewProvider == null) return;
    
    setState(() {
      isLoadingReviews = true;
    });

    try {
      var filter = <String, dynamic>{
        'movieId': widget.movie.id,
        'includeDeleted': false,
      };
      
      reviewsResult = await reviewProvider!.get(filter: filter);
      setState(() {
        reviewsResult = reviewsResult;
        isLoadingReviews = false;
      });
    } catch (e) {
      print('Error loading reviews: $e');
      setState(() {
        isLoadingReviews = false;
      });
    }
  }

    Future<void> _loadGenres() async {
      if (widget.movie.id == null || genreProvider == null) return;

      setState(() {
        isLoadingGenres = true; 
      });

      try {
        var filter = <String, dynamic>{
        };

        var genres = await genreProvider!.get(filter: filter);
        setState(() {
          genres = genres;
          isLoadingGenres = false;
        });
        print("Genres: $genres");
      }catch (e) {
        print('Error loading genres: $e');
        setState(() {
          isLoadingGenres = false;
        });
      }
    }

    Future<void> _loadActors() async {
      if (widget.movie.id == null || actorProvider == null) return;

      setState(() {
        isLoadingActors = true;
      });

      try {
        var filter = <String, dynamic>{
        };

        var actors = await actorProvider!.get(filter: filter);
        setState(() {
          actors = actors;
          isLoadingActors = false;
        });
      }catch (e) {
        print('Error loading actors: $e');
        setState(() {
          isLoadingActors = false;
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final movie = detailedMovie ?? widget.movie;

    return MasterScreen(
      movie.title ?? l10n.movieDetails,
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: isLoading 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(l10n.loadingMovieDetails),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300,
                            height: 450,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: movie.image != null && movie.image!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: imageFromString(movie.image!),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.movie, size: 80, color: Colors.grey[400]),
                                      const SizedBox(height: 16),
                                      Text(
                                        l10n.noImage,
                                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                                      ),
                                    ],
                                  ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditMovieScreen(movie: movie),
                                    ),
                                  );
                                  
                                  if (result == true) {
                                    await _loadMovieDetails();
                                  }
                                },
                                icon: const Icon(Icons.edit),
                                label: Text(l10n.editMovie),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              ),
                              const SizedBox(width: 16),
                              if (movie.isDeleted == true)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _showRestoreConfirmationDialog(movie);
                                  },
                                  icon: const Icon(Icons.restore),
                                  label: Text(l10n.restoreMovie),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[600],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                )
                              else
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(movie);
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: Text(l10n.deleteMovie),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.error,
                                    foregroundColor: Theme.of(context).colorScheme.onError,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      
                      const SizedBox(width: 32),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    movie.title ?? l10n.unknownTitle,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (movie.isDeleted == true)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.red[600],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      l10n.deleted,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),
                            
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  movie.grade?.toStringAsFixed(1) ?? "N/A",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            _buildDetailRow(l10n.director, movie.director ?? l10n.unknown),
                            
                            _buildDetailRow(l10n.duration, "${movie.durationMinutes ?? 0} ${l10n.minutes}"),
                            
                            _buildDetailRow(l10n.releaseDate, 
                              movie.releaseDate != null 
                                ? "${movie.releaseDate!.day}/${movie.releaseDate!.month}/${movie.releaseDate!.year}"
                                : l10n.unknown
                            ),
                            
                            _buildDetailRow(l10n.releaseYear, movie.releaseYear?.toString() ?? l10n.unknown),
                            
                            _buildDetailRow(l10n.genres, 
                              movie.genres != null && movie.genres!.isNotEmpty
                                ? movie.genres!.map((g) => g.name).join(", ")
                                : l10n.noGenresAssigned
                            ),
                            
                            _buildDetailRow(l10n.actors, 
                              movie.actors != null && movie.actors!.isNotEmpty
                                ? movie.actors!.map((a) => "${a.firstName} ${a.lastName}").join(", ")
                                : l10n.noActorsAssigned
                            ),
                            
                            if (movie.trailerUrl != null && movie.trailerUrl!.isNotEmpty)
                              _buildDetailRow(l10n.trailer, movie.trailerUrl!),
                            
                            const SizedBox(height: 24),
                            
                            if (movie.description != null && movie.description!.isNotEmpty) ...[
                              Text(
                                l10n.description,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.description!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            
                            const SizedBox(height: 32),
                            
                            _buildReviewsSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
      ), showDrawer: false
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final l10n = AppLocalizations.of(context)!;
    final movie = detailedMovie ?? widget.movie;
    final reviews = reviewsResult?.items ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.rate_review,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.reviews2,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (isLoadingReviews)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        movie.grade?.toStringAsFixed(1) ?? '0.0',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${reviews.length} ${l10n.reviews})',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (isLoadingReviews)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(l10n.loadingReviews),
                    ],
                  ),
                ),
              )
            else if (reviews.isNotEmpty) ...[
              ...reviews.take(2).map((review) => _buildReviewPreview(review)),
              if (reviews.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.andMoreReviews(reviews.length - 2),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ] else ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.rate_review,
                        size: 48,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noReviewsYet,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsScreen(movie: widget.movie),
                        ),
                      );
                      _loadReviews();
                    },
                    icon: const Icon(Icons.visibility),
                    label: Text(l10n.viewAllReviews),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewPreview(Review review) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 16,
            child: Text(
              review.userName.isNotEmpty ? review.userName[0].toUpperCase() : 'U',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.userName.isNotEmpty ? review.userName : l10n.unknown,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      review.rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (review.comment != null && review.comment!.isNotEmpty)
                  Text(
                    review.comment!,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Movie movie) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeletion),
        content: Text(l10n.confirmDeleteMovie(movie.title ?? l10n.unknownTitle)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteMovie(movie);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMovie(Movie movie) async {
    final l10n = AppLocalizations.of(context)!;
    if (movieProvider == null || movie.id == null) return;
    
    try {
      await movieProvider!.softDelete(movie.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.movieDeletedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error deleting movie: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToDeleteMovie),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRestoreConfirmationDialog(Movie movie) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmRestoration),
        content: Text(l10n.confirmRestoreMovie(movie.title ?? l10n.unknownTitle)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restoreMovie(movie);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n.restore),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreMovie(Movie movie) async {
    final l10n = AppLocalizations.of(context)!;
    if (movieProvider == null || movie.id == null) return;
    
    try {
      await movieProvider!.restore(movie.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.movieRestoredSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error restoring movie: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToRestoreMovie),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
