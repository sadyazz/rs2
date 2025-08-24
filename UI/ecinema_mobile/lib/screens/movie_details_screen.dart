import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/screening.dart';
import '../models/actor.dart';
import '../providers/screening_provider.dart';
import '../providers/review_provider.dart';
import '../providers/user_movie_list_provider.dart';
import '../providers/utils.dart';
import '../models/review.dart';
import 'reviews_screen.dart';
import 'reservation_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  List<Screening> screenings = <Screening>[];
  List<Actor> actors = <Actor>[];
  List<Review> reviews = <Review>[];
  bool isLoadingScreenings = false;
  bool isLoadingActors = false;
  bool isLoadingReviews = false;
  bool isLoadingWatchlistStatus = false;
  bool isLoadingFavoritesStatus = false;
  bool isInWatchlist = false;
  bool isInFavorites = false;
    String selectedDate = '';
  String selectedTime = '';
  String selectedLocation = '';
  Set<int> revealedSpoilers = <int>{};
  bool _isDescriptionExpanded = false;

  bool get isComingSoon => widget.movie.isComingSoon == true;

  @override
  void initState() {
    super.initState();
    _loadScreenings();
    _loadActors();
    _loadReviews();
    _loadListStatuses();
  }

  Future<void> _loadListStatuses() async {
    try {
      setState(() {
        isLoadingWatchlistStatus = true;
        isLoadingFavoritesStatus = true;
      });

      final userMovieListProvider = UserMovieListProvider();
      
      final watchlistStatus = await userMovieListProvider.isMovieInList(widget.movie.id!, 'watchlist');
      final favoritesStatus = await userMovieListProvider.isMovieInList(widget.movie.id!, 'favorites');

      setState(() {
        isInWatchlist = watchlistStatus;
        isInFavorites = favoritesStatus;
        isLoadingWatchlistStatus = false;
        isLoadingFavoritesStatus = false;
      });
    } catch (e) {
      print('Error loading list statuses: $e');
      setState(() {
        isLoadingWatchlistStatus = false;
        isLoadingFavoritesStatus = false;
      });
    }
  }

  Future<void> _toggleWatchlist(AppLocalizations l10n) async {
    try {
      setState(() {
        isLoadingWatchlistStatus = true;
      });

      final userMovieListProvider = UserMovieListProvider();
      
      if (isInWatchlist) {
        await userMovieListProvider.removeMovieFromList(widget.movie.id!, 'watchlist');
      } else {
        await userMovieListProvider.addMovieToList(widget.movie.id!, 'watchlist');
      }

      setState(() {
        isInWatchlist = !isInWatchlist;
        isLoadingWatchlistStatus = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isInWatchlist 
                ? l10n.addedToWatchlist 
                : l10n.removedFromWatchlist,
          ),
        ),
      );
    } catch (e) {
      print('Error toggling watchlist: $e');
      setState(() {
        isLoadingWatchlistStatus = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorUpdatingWatchlist),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleFavorites(AppLocalizations l10n) async {
    try {
      setState(() {
        isLoadingFavoritesStatus = true;
      });

      final userMovieListProvider = UserMovieListProvider();
      
      if (isInFavorites) {
        await userMovieListProvider.removeMovieFromList(widget.movie.id!, 'favorites');
      } else {
        await userMovieListProvider.addMovieToList(widget.movie.id!, 'favorites');
      }

      setState(() {
        isInFavorites = !isInFavorites;
        isLoadingFavoritesStatus = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isInFavorites 
                ? l10n.addedToFavorites 
                : l10n.removedFromFavorites,
          ),
        ),
      );
    } catch (e) {
      print('Error toggling favorites: $e');
      setState(() {
        isLoadingFavoritesStatus = false;
      });
      String errorMessage = l10n.errorUpdatingFavorites;
      if (e.toString().contains("Coming soon movies can only be added to watchlist")) {
        errorMessage = l10n.comingSoonWatchlistOnly;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateSelectedTime() {
    if (screenings.isNotEmpty) {
      final l10n = AppLocalizations.of(context)!;
      final dates = _extractDatesFromScreenings(l10n);
      final times = _extractTimesFromScreenings(l10n);
      
      if (dates.isNotEmpty && selectedDate.isEmpty) {
        setState(() {
          selectedDate = dates.first;
        });
      }
      
      if (times.isNotEmpty) {
        setState(() {
          selectedTime = times.first;
        });
      }
    }
  }

  Future<void> _loadActors() async {
    try {
      setState(() {
        isLoadingActors = true;
      });

      if (widget.movie.actors != null) {
        setState(() {
          actors = widget.movie.actors!;
        });
      }
    } catch (e) {
      print('Error loading actors: $e');
    } finally {
      setState(() {
        isLoadingActors = false;
      });
    }
  }

  Future<void> _loadReviews() async {
    try {
      setState(() {
        isLoadingReviews = true;
      });
      
      
      final reviewProvider = context.read<ReviewProvider>();
      var filter = <String, dynamic>{
        'page': 0,
        'pageSize': 10,
        'includeTotalCount': true,
        'movieId': widget.movie.id,
        'includeDeleted': false,
        'fromStartTime': DateTime.now().toIso8601String(),
      };
      
      
      final result = await reviewProvider.get(filter: filter);
      
      if (result.items != null) {
        setState(() {
          reviews = result.items!.cast<Review>();
        });
      }
    } catch (e) {
      print('Error loading reviews: $e');
    } finally {
      setState(() {
        isLoadingReviews = false;
      });
    }
  }

  Future<void> _loadScreenings() async {
    try {
      setState(() {
        isLoadingScreenings = true;
      });

      final screeningProvider = context.read<ScreeningProvider>();
      var filter = <String, dynamic>{
        'page': 0,
        'pageSize': 50,
        'includeTotalCount': true,
        'movieId': widget.movie.id,
        'includeDeleted': false,
        'fromStartTime': DateTime.now().toIso8601String(),
      };
      
      if (widget.movie.title != null && widget.movie.title!.isNotEmpty) {
        filter['movieTitle'] = widget.movie.title;
      }

      final result = await screeningProvider.get(filter: filter);
      
      if (result.items != null) {
        setState(() {
          screenings = result.items!.cast<Screening>();
        });
        _updateSelectedTime();
      }
    } catch (e) {
      print('Error loading screenings: $e');
    } finally {
      setState(() {
        isLoadingScreenings = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: colorScheme.surface,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                width: double.infinity,
                height: 300,
                child: widget.movie.image != null && widget.movie.image!.isNotEmpty
                    ? imageFromString(widget.movie.image!)
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
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.movie, size: 80, color: colorScheme.onSurfaceVariant),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noImage,
                              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMovieInfo(l10n, colorScheme),
                  const SizedBox(height: 24),
                  if (isComingSoon)
                    _buildComingSoonActions(l10n, colorScheme)
                  else
                    _buildActionButtons(l10n, colorScheme),
                  const SizedBox(height: 24),
                  if (!isComingSoon) ...[
                    _buildScreeningsSection(l10n, colorScheme),
                    const SizedBox(height: 24),
                  ],
                  _buildMovieDescription(l10n, colorScheme),
                  const SizedBox(height: 24),
                  _buildActorsSection(l10n, colorScheme),
                  if (!isComingSoon) ...[
                    const SizedBox(height: 24),
                    _buildReviewsSection(l10n, colorScheme),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonActions(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoadingWatchlistStatus ? null : () => _toggleWatchlist(l10n),
                icon: isLoadingWatchlistStatus 
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        isInWatchlist ? Icons.bookmark : Icons.bookmark_add,
                        color: Colors.white,
                        size: 24,
                      ),
                label: Text(
                  isInWatchlist ? l10n.removeFromWatchlist : l10n.addToWatchlist,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInWatchlist 
                      ? Colors.grey[600]
                      : const Color(0xFF4F8593),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.event,
                color: colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.releaseDate,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _formatReleaseDate(widget.movie.releaseDate),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatReleaseDate(DateTime? releaseDate) {
    final l10n = AppLocalizations.of(context)!;
    
    if (releaseDate == null) return l10n.tba;
    
    final months = [
      l10n.january, l10n.february, l10n.march, l10n.april, l10n.may, l10n.june,
      l10n.july, l10n.august, l10n.september, l10n.october, l10n.november, l10n.december
    ];
    
    return '${months[releaseDate.month - 1]} ${releaseDate.day}, ${releaseDate.year}';
  }

  Widget _buildMovieInfo(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title ?? l10n.unknownTitle,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        widget.movie.releaseYear?.toString() ?? l10n.unknown,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.movie.durationMinutes != null ? '${widget.movie.durationMinutes} min' : l10n.unknown,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.movie.genres?.isNotEmpty == true 
                                            ? widget.movie.genres!.first.name ?? l10n.unknown
                : l10n.unknown,
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.movie.grade != null && !isComingSoon)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${widget.movie.grade!.toStringAsFixed(1)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                              onPressed: () {
                if (selectedTime.isNotEmpty && selectedDate.isNotEmpty) {
                  final screening = _getScreeningForTime(selectedTime);
                  if (screening != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationScreen(
                          movie: widget.movie,
                          screening: screening,
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.pleaseSelectScreening),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
                icon: const Icon(Icons.movie_filter_rounded, color: Colors.white, size: 24),
                label: Text(
                  l10n.reserveTicket,
                  style: const TextStyle(color: Colors.white),
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
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoadingFavoritesStatus ? null : () => _toggleFavorites(l10n),
                icon: isLoadingFavoritesStatus 
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        isInFavorites ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 24,
                      ),
                label: Text(
                  isInFavorites ? l10n.removeFromFavorites : l10n.addToFavorites,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInFavorites 
                      ? Colors.red[600]
                      : const Color(0xFF4F8593),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoadingWatchlistStatus ? null : () => _toggleWatchlist(l10n),
                icon: isLoadingWatchlistStatus 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(
                        isInWatchlist ? Icons.bookmark : Icons.bookmark_add,
                        color: Colors.white,
                        size: 20,
                      ),
                label: Text(
                  isInWatchlist ? l10n.removeFromWatchlist : l10n.addToWatchlist,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInWatchlist 
                      ? Colors.grey[600]
                      : const Color(0xFF4F8593),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScreeningsSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.screeningTimes,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildDateSelector(l10n, colorScheme),
        const SizedBox(height: 12),
        const SizedBox(height: 16),
        _buildTimeSelector(l10n, colorScheme),
      ],
    );
  }

  Widget _buildDateSelector(AppLocalizations l10n, ColorScheme colorScheme) {
    final dates = _extractDatesFromScreenings(l10n);
    final cardSize = 80.0;
    
    if (dates.isEmpty) {
      return SizedBox(
        height: cardSize,
        child: Center(
          child:             Text(
              l10n.noAvailableDates,
              style: TextStyle(
                color: colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
        ),
      );
    }
    
    return SizedBox(
      height: cardSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = date == selectedDate;
          final parts = date.split(' ');
          final datePart = parts[0];
          final dayName = parts[1];
          final dateParts = datePart.split('.');
          final day = dateParts[0];
          final month = dateParts[1];
          
          return Container(
            width: cardSize,
            height: cardSize,
            margin: EdgeInsets.only(right: index < dates.length - 1 ? 12 : 0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                  _updateSelectedTime();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? colorScheme.primary
                        : colorScheme.surfaceVariant.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? colorScheme.primary
                          : colorScheme.outline.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day.$month',
                        style: TextStyle(
                          color: isSelected 
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        dayName,
                        style: TextStyle(
                          color: isSelected 
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<String> _extractDatesFromScreenings(AppLocalizations l10n) {
    if (screenings.isEmpty) return [];
    
    final dates = <String>{};
    for (final screening in screenings) {
      if (screening.startTime != null) {
        final day = screening.startTime!.day.toString().padLeft(2, '0');
        final month = screening.startTime!.month.toString().padLeft(2, '0');
        final weekday = _getWeekdayName(screening.startTime!.weekday, l10n);
        final dateString = '$day.$month $weekday';
        dates.add(dateString);
      }
    }
    final result = dates.toList();
    result.sort((a, b) {
      final aDate = a.split(' ')[0];
      final bDate = b.split(' ')[0];
      final aParts = aDate.split('.');
      final bParts = bDate.split('.');
      final aDay = int.parse(aParts[0]);
      final aMonth = int.parse(aParts[1]);
      final bDay = int.parse(bParts[0]);
      final bMonth = int.parse(bParts[1]);
      
      if (aMonth != bMonth) {
        return aMonth.compareTo(bMonth);
      }
      return aDay.compareTo(bDay);
    });
    return result;
  }

  String _getWeekdayName(int weekday, AppLocalizations l10n) {
    switch (weekday) {
      case DateTime.monday:
        return l10n.monday;
      case DateTime.tuesday:
        return l10n.tuesday;
      case DateTime.wednesday:
        return l10n.wednesday;
      case DateTime.thursday:
        return l10n.thursday;
      case DateTime.friday:
        return l10n.friday;
      case DateTime.saturday:
        return l10n.saturday;
      case DateTime.sunday:
        return l10n.sunday;
      default:
        return l10n.monday;
    }
  }

  List<String> _extractTimesFromScreenings(AppLocalizations l10n) {
    if (screenings.isEmpty) return [];
    
    final times = <String>{};
    for (final screening in screenings) {
      if (screening.startTime != null) {
        final day = screening.startTime!.day.toString().padLeft(2, '0');
        final month = screening.startTime!.month.toString().padLeft(2, '0');
        final screeningDate = '$day.$month ${_getWeekdayName(screening.startTime!.weekday, l10n)}';
        if (screeningDate == selectedDate) {
          final timeString = '${screening.startTime!.hour.toString().padLeft(2, '0')}:${screening.startTime!.minute.toString().padLeft(2, '0')}';
          times.add(timeString);
        }
      }
    }
    return times.toList()..sort();
  }

  Widget _buildTimeSelector(AppLocalizations l10n, ColorScheme colorScheme) {
    if (screenings.isEmpty) {
      return Center(
        child: Text(
          l10n.noAvailableScreenings,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
      );
    }

    final times = _extractTimesFromScreenings(l10n);
    
    if (times.isEmpty) {
      return Center(
        child: Text(
          l10n.noAvailableTimes,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
      );
    }

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: times.length,
        itemBuilder: (context, index) {
          final time = times[index];
          return Container(
            width: 120,
            height: 100,
            margin: EdgeInsets.only(right: index < times.length - 1 ? 8 : 0),
            child: _buildTimeButton(time, colorScheme),
          );
        },
      ),
    );
  }

  Widget _buildTimeButton(String time, ColorScheme colorScheme) {
    final isSelected = time == selectedTime;
    final screening = _getScreeningForTime(time);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTime = time;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected 
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (screening != null) ...[
                  const SizedBox(height: 4),
                  if (screening.hallName != null)
                    Text(
                      screening.hallName!,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      // maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (screening.screeningFormatName != null)
                        Text(
                          screening.screeningFormatName!,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (screening.hasSubtitles == true) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.subtitles,
                          color: colorScheme.primary,
                          size: 14,
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Screening? _getScreeningForTime(String time) {
    for (final screening in screenings) {
      if (screening.startTime != null) {
        final day = screening.startTime!.day.toString().padLeft(2, '0');
        final month = screening.startTime!.month.toString().padLeft(2, '0');
        final screeningDate = '$day.$month ${_getWeekdayName(screening.startTime!.weekday, AppLocalizations.of(context)!)}';
        final timeString = '${screening.startTime!.hour.toString().padLeft(2, '0')}:${screening.startTime!.minute.toString().padLeft(2, '0')}';
        
        if (screeningDate == selectedDate && timeString == time) {
          return screening;
        }
      }
    }
    return null;
  }

  Widget _buildMovieDescription(AppLocalizations l10n, ColorScheme colorScheme) {
    final description = widget.movie.description ?? l10n.noDescriptionAvailable;
    final isLongDescription = description.length > 150;
    
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.description,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.8),
                height: 1.5,
              ),
              maxLines: _isDescriptionExpanded ? null : (isLongDescription ? 3 : null),
              overflow: _isDescriptionExpanded ? null : (isLongDescription ? TextOverflow.ellipsis : null),
            ),
            if (isLongDescription && !_isDescriptionExpanded) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setLocalState(() {
                    _isDescriptionExpanded = true;
                  });
                },
                child: Text(l10n.showMore),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildActorsSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.actors,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isLoadingActors)
          Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          )
        else if (actors.isEmpty)
          Text(
            l10n.actorInfoComingSoon,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: actors.length,
              itemBuilder: (context, index) {
                final actor = actors[index];
                return Container(
                  width: 100,
                  margin: EdgeInsets.only(right: index < actors.length - 1 ? 12 : 0),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.surfaceVariant,
                        ),
                        child: actor.image != null && actor.image!.isNotEmpty
                            ? ClipOval(
                                child: imageFromString(actor.image!),
                              )
                            : Icon(
                                Icons.person,
                                size: 40,
                                color: colorScheme.onSurfaceVariant,
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${actor.firstName ?? ''} ${actor.lastName ?? ''}'.trim().isEmpty 
                            ? l10n.unknown 
                            : '${actor.firstName ?? ''} ${actor.lastName ?? ''}'.trim(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildReviewsSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.reviews2,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (reviews.isNotEmpty)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewsScreen(movie: widget.movie),
                    ),
                  );
                },
                child: Text(l10n.viewAllReviews),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (isLoadingReviews)
          Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          )
        else if (reviews.isEmpty)
          Text(
            l10n.noReviewsYet,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          )
        else
          Column(
            children: [
              ...reviews.take(2).map((review) => _buildReviewCard(review, l10n, colorScheme)),
              if (reviews.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.andMoreReviews(reviews.length - 2),
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildReviewCard(Review review, AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primary,
                radius: 16,
                backgroundImage: review.userImage != null
                    ? imageFromString(review.userImage!).image
                    : null,
                child: review.userImage == null
                    ? Text(
                        (review.userName?.isNotEmpty == true) ? review.userName![0].toUpperCase() : 'U',
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          (review.userName?.isNotEmpty == true) ? review.userName! : l10n.unknownUser,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (review.isSpoiler == true)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.spoiler,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      _formatDate(review.createdAt ?? DateTime.now()),
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < (review.rating ?? 0)
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                  const SizedBox(width: 4),
                  Text(
                    '${review.rating}/5',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 8),
            if (review.isSpoiler == true)
              _buildSpoilerContent(review, l10n, colorScheme)
            else
              Text(
                review.comment!,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpoilerContent(Review review, AppLocalizations l10n, ColorScheme colorScheme) {
    final isRevealed = revealedSpoilers.contains(review.id);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_off,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.spoilerContent,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (isRevealed) ...[
          const SizedBox(height: 8),
          Text(
            review.comment!,
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  String _formatDate(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return l10n.today;
    } else if (difference.inDays == 1) {
      return l10n.yesterday;
    } else if (difference.inDays < 7) {
      return l10n.daysAgo(difference.inDays);
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 