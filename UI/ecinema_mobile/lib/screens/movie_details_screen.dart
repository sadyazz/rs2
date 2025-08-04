import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/screening.dart';
import '../models/actor.dart';
import '../providers/screening_provider.dart';
import '../providers/actor_provider.dart';
import '../providers/review_provider.dart';
import '../providers/utils.dart';
import '../models/review.dart';
import '../models/search_result.dart';
import 'reviews_screen.dart';

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
  String selectedDate = '';
  String selectedTime = '';
  String selectedLocation = 'Sarajevo';
  Set<int> revealedSpoilers = <int>{};

  @override
  void initState() {
    super.initState();
    _loadScreenings();
    _loadActors();
    _loadReviews();
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
      };
      
      
      final result = await reviewProvider.get(filter: filter);
      
      if (result != null && result.items != null) {
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
      };
      
      if (widget.movie.title != null && widget.movie.title!.isNotEmpty) {
        filter['movieTitle'] = widget.movie.title;
      }

      final result = await screeningProvider.get(filter: filter);
      
      if (result != null && result.items != null) {
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
                  _buildActionButtons(l10n, colorScheme),
                  const SizedBox(height: 24),
                  _buildScreeningsSection(l10n, colorScheme),
                  const SizedBox(height: 24),
                  _buildMovieDescription(l10n, colorScheme),
                  const SizedBox(height: 24),
                  _buildActorsSection(l10n, colorScheme),
                  const SizedBox(height: 24),
                  _buildReviewsSection(l10n, colorScheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                    widget.movie.title ?? 'Unknown Title',
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
                        '${widget.movie.releaseYear ?? 2024}',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${widget.movie.durationMinutes ?? 120} min',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.movie.genres?.isNotEmpty == true 
                            ? widget.movie.genres!.first.name ?? 'Unknown'
                            : 'Unknown',
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
            if (widget.movie.grade != null)
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
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement ticket reservation
            },
            icon: const Icon(Icons.movie_filter_rounded, color: Colors.white, size: 24,),
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
            onPressed: () {
              // TODO: Implement add to favorites
            },
            icon: const Icon(Icons.favorite, color: Colors.white, size: 24,),
            label: Text(
              l10n.addToFavorites,
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
        // _buildLocationInfo(colorScheme), // Zakomentarisano kao što je traženo
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

  Widget _buildLocationInfo(AppLocalizations l10n, ColorScheme colorScheme) {
    final location = _extractLocationFromScreenings();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                location,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.location_on,
                color: colorScheme.onSurface,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimeSelector(l10n, colorScheme),
        ],
      ),
    );
  }

  String _extractLocationFromScreenings() {
    if (screenings.isEmpty) return 'Sarajevo';
    
    final locations = <String>{};
    for (final screening in screenings) {
      if (screening.hallName != null && screening.hallName!.isNotEmpty) {
        locations.add(screening.hallName!);
      }
    }
    
    return locations.isNotEmpty ? locations.first : 'Sarajevo';
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
          widget.movie.description ?? 'Priča o američkom naučniku J. Robert Oppenheimeru i njegovoj ulozi u razvoju atomske bombe. Film prati dramatične događaje koji su doveli do uspješnog testiranja prve nuklearne bombe u povijesti.',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
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
                            ? 'Unknown' 
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
                child: Text(
                  (review.userName?.isNotEmpty == true) ? review.userName![0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
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