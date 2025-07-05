import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/movie_provider.dart';
import 'package:ecinema_desktop/providers/utils.dart';
import 'package:ecinema_desktop/screens/movie_details_screen.dart';
import 'package:ecinema_desktop/screens/edit_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late MovieProvider provider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = context.read<MovieProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMovies();
    });
  }

  SearchResult<Movie>? result = null;
  int currentPage = 0;
  int pageSize = 15;
  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _genresController = TextEditingController();
  final TextEditingController _minDurationController = TextEditingController();
  final TextEditingController _maxDurationController = TextEditingController();
  final TextEditingController _minGradeController = TextEditingController();
  final TextEditingController _maxGradeController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();
  bool isActive = true;

  Future<void> _loadMovies() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      var filter = <String, dynamic>{
        'page': currentPage,
        'pageSize': pageSize,
        'includeTotalCount': true,
        'isActive': true,
        'isDeleted': false,
      };
      result = await provider.get(filter: filter);
      setState(() {
        result = result;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading movies: $e');
      setState(() {
        isLoading = false;
      });
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
        'isActive': isActive,
        'isDeleted': false,
      };
      
      if (_searchController.text.isNotEmpty) {
        filter["title"] = _searchController.text;
      }
      if (_directorController.text.isNotEmpty) {
        filter["director"] = _directorController.text;
      }
      if (_genresController.text.isNotEmpty) {
        try {
          var genreIds = _genresController.text
              .split(',')
              .map((e) => int.tryParse(e.trim()))
              .where((e) => e != null)
              .cast<int>()
              .toList();
          if (genreIds.isNotEmpty) {
            filter["genreIds"] = genreIds;
          }
        } catch (e) {
          print('Error parsing genre IDs: $e');
        }
      }
      if (_minDurationController.text.isNotEmpty) {
        filter["minDuration"] = int.tryParse(_minDurationController.text);
      }
      if (_maxDurationController.text.isNotEmpty) {
        filter["maxDuration"] = int.tryParse(_maxDurationController.text);
      }
      if (_minGradeController.text.isNotEmpty) {
        filter["minGrade"] = double.tryParse(_minGradeController.text);
      }
      if (_maxGradeController.text.isNotEmpty) {
        filter["maxGrade"] = double.tryParse(_maxGradeController.text);
      }
      if (_releaseYearController.text.isNotEmpty) {
        filter["releaseYear"] = int.tryParse(_releaseYearController.text);
      }
      
      result = await provider.get(filter: filter);
      setState(() {
        result = result;
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

  void _goToNextPage() {
    if (result != null && result!.items!.length == pageSize) {
      setState(() {
        currentPage++;
      });
      _loadMovies();
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

  void _resetPagination() {
    setState(() {
      currentPage = 0;
    });
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(l10n.movies,
      Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 16.0),
        child: Column(
          children: [
            _buildSearch(),
            _BuildResultView()
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    final l10n = AppLocalizations.of(context)!;
    final primaryColor = Theme.of(context).colorScheme.primary;
    OutlineInputBorder roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 36,
            child: TextField( 
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.search,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide(color: primaryColor, width: 2.5),
                ),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () async {
              await _searchMovies();
            },
            icon: const Icon(Icons.search, size: 18),
            label: Text(l10n.search),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  bool localIsActive = isActive;
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 80),
                      content: SizedBox(
                        width: 440,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _directorController,
                                decoration: InputDecoration(
                                  labelText: l10n.director,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _genresController,
                                decoration: InputDecoration(
                                  labelText: l10n.genreIds,
                                  hintText: l10n.genreIdsHint,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _minDurationController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: l10n.minDuration,
                                        border: roundedBorder,
                                        enabledBorder: roundedBorder,
                                        focusedBorder: roundedBorder,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _maxDurationController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: l10n.maxDuration,
                                        border: roundedBorder,
                                        enabledBorder: roundedBorder,
                                        focusedBorder: roundedBorder,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _minGradeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: l10n.minGrade,
                                        border: roundedBorder,
                                        enabledBorder: roundedBorder,
                                        focusedBorder: roundedBorder,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _maxGradeController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: l10n.maxGrade,
                                        border: roundedBorder,
                                        enabledBorder: roundedBorder,
                                        focusedBorder: roundedBorder,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _releaseYearController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: l10n.releaseYear,
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(l10n.isActive),
                                  const SizedBox(width: 8),
                                  Switch(
                                    value: localIsActive,
                                    onChanged: (val) {
                                      setState(() => localIsActive = val);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _directorController.clear();
                            _genresController.clear();
                            _minDurationController.clear();
                            _maxDurationController.clear();
                            _minGradeController.clear();
                            _maxGradeController.clear();
                            _releaseYearController.clear();
                            setState(() {
                              localIsActive = true;
                              isActive = true;
                            });
                          },
                          child: Text(l10n.reset),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(l10n.close),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isActive = localIsActive;
                            });
                            await _searchMovies();
                            Navigator.pop(context);
                          },
                          child: Text(l10n.apply),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_alt_outlined),
            label: Text(l10n.filters),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditMovieScreen(),
                ),
              );
              
              if (result == true) {
                _resetPagination();
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: Text(l10n.addMovie),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              minimumSize: const Size(0, 36),
            ),
          ),
        ),
      ],
    );
  }

  Widget _BuildResultView(){
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                l10n.loadingMovies,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    if (result == null) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                l10n.noMoviesLoaded,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    if (result!.items!.isEmpty) {
    return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                l10n.noMoviesFound,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                l10n.tryAdjustingSearch,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 5),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: result!.items!.length,
                itemBuilder: (context, index) {
                  final movie = result!.items![index];
                  return _buildMovieCard(movie);
                },
              ),
            ),
          ),
          _buildPaginationControls(),
        ],
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movie: movie),
          ),
        );
        
        _resetPagination();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
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
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.surfaceVariant,
                          Theme.of(context).colorScheme.outline.withOpacity(0.3),
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
                              Icon(Icons.movie, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              const SizedBox(height: 8),
                              Text(
                                l10n.noImage,
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                              ),
                            ],
                          ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: movie.isActive == true ? Colors.green[600] : Colors.red[600],
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
                      child: Text(
                        movie.isActive == true ? l10n.active : l10n.inactive,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (movie.grade != null)
                    Positioned(
                      top: 10,
                      right: 10,
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
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title ?? l10n.unknownTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    
                    Text(
                      movie.director ?? l10n.unknownDirector,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    Row(
                      children: [
                        if (movie.genres != null && movie.genres!.isNotEmpty)
                          Expanded(
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 1,
                              children: movie.genres!.take(1).map((genre) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), width: 0.5),
                                ),
                                child: Text(
                                  genre.name ?? l10n.unknown,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )).toList(),
                            ),
                          ),
                        
                        if (movie.durationMinutes != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, size: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                              const SizedBox(width: 2),
                              Text(
                                "${movie.durationMinutes}m",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
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

  Widget _buildPaginationControls() {
    final l10n = AppLocalizations.of(context)!;
    if (result == null) return const SizedBox.shrink();
    
    final totalCount = result!.totalCount ?? 0;
    final currentItems = result!.items!.length;
    final hasNextPage = currentItems == pageSize;
    final hasPreviousPage = currentPage > 0;
    final totalPages = (totalCount / pageSize).ceil();
    
    return Container(
      margin: const EdgeInsets.only(top: 4, bottom: 2),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
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
              borderRadius: BorderRadius.circular(6),
              color: hasPreviousPage 
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: hasPreviousPage ? _goToPreviousPage : null,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_left,
                        size: 14,
                        color: hasPreviousPage 
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        l10n.previous,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: hasPreviousPage 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
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
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                '$currentItems ${l10n.ofText} $totalCount',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: hasNextPage 
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: hasNextPage ? _goToNextPage : null,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.next,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: hasNextPage 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 14,
                        color: hasNextPage 
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
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