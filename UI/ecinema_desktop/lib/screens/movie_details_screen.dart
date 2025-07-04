import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/actor.dart';
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
        'isActive': true,
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
          'isActive': true,
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
          'isActive': true,
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
    final movie = detailedMovie ?? widget.movie;

    return MasterScreen(
      "Movie Details",
      Padding(
        padding: const EdgeInsets.all(32.0),
        child: isLoading 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading movie details..."),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        tooltip: 'Back to movies',
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          movie.title ?? "Unknown Movie",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
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
                                        "No Image",
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
                                  
                                  // Refresh movie details if edit was successful
                                  if (result == true) {
                                    await _loadMovieDetails();
                                  }
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Movie'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  _showDeleteConfirmationDialog(movie);
                                },
                                icon: const Icon(Icons.delete),
                                label: const Text('Delete Movie'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[600],
                                  foregroundColor: Colors.white,
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
                                    movie.title ?? "Unknown Title",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: movie.isActive == true ? Colors.green[600] : Colors.red[600],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    movie.isActive == true ? "Active" : "Inactive",
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
                            
                            _buildDetailRow("Director", movie.director ?? "Unknown"),
                            
                            _buildDetailRow("Duration", "${movie.durationMinutes ?? 0} minutes"),
                            
                            _buildDetailRow("Release Date", 
                              movie.releaseDate != null 
                                ? "${movie.releaseDate!.day}/${movie.releaseDate!.month}/${movie.releaseDate!.year}"
                                : "Unknown"
                            ),
                            
                            _buildDetailRow("Release Year", movie.releaseYear?.toString() ?? "Unknown"),
                            
                            _buildDetailRow("Genres", 
                              movie.genres != null && movie.genres!.isNotEmpty
                                ? movie.genres!.map((g) => g.name).join(", ")
                                : "No genres assigned"
                            ),
                            
                            _buildDetailRow("Actors", 
                              movie.actors != null && movie.actors!.isNotEmpty
                                ? movie.actors!.map((a) => "${a.firstName} ${a.lastName}").join(", ")
                                : "No actors assigned"
                            ),
                            
                            if (movie.trailerUrl != null && movie.trailerUrl!.isNotEmpty)
                              _buildDetailRow("Trailer", movie.trailerUrl!),
                            
                            const SizedBox(height: 24),
                            
                            if (movie.description != null && movie.description!.isNotEmpty) ...[
                              const Text(
                                "Description",
                                style: TextStyle(
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
                            
                            // Reviews Section
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
      ),
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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
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
    final movie = detailedMovie ?? widget.movie;
    final reviews = reviewsResult?.result ?? [];

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
                  'Reviews',
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
                        '(${reviews.length} reviews)',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Preview of recent reviews
            if (isLoadingReviews)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Loading reviews..."),
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
                    '... and ${reviews.length - 2} more reviews',
                    style: TextStyle(
                      color: Colors.grey[600],
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
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No reviews yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to review this movie!',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsScreen(movie: widget.movie),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View All Reviews'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
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
              style: const TextStyle(
                color: Colors.white,
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
                      review.userName.isNotEmpty ? review.userName : 'Unknown User',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${movie.title ?? 'Unknown Movie'}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteMovie(movie);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMovie(Movie movie) async {
    if (movieProvider == null || movie.id == null) return;
    
    try {
      await movieProvider!.delete(movie.id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Movie deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print('Error deleting movie: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete movie'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
