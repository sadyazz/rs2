import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/movie_provider.dart';
import 'package:ecinema_desktop/providers/utils.dart';
import 'package:ecinema_desktop/screens/movie_details_screen.dart';
import 'package:ecinema_desktop/screens/edit_movie_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _directorController = TextEditingController();
  final TextEditingController _genresController = TextEditingController();
  final TextEditingController _minDurationController = TextEditingController();
  final TextEditingController _maxDurationController = TextEditingController();
  final TextEditingController _minGradeController = TextEditingController();
  final TextEditingController _maxGradeController = TextEditingController();
  final TextEditingController _releaseYearController = TextEditingController();
  bool isActive = true;

  // Metoda za učitavanje filmova
  Future<void> _loadMovies() async {
    try {
      var filter = <String, dynamic>{};
      result = await provider.get(filter: filter);
      setState(() {
        result = result;
      });
    } catch (e) {
      print('Error loading movies: $e');
    }
  }

  // Metoda za pretragu filmova sa filterima
  Future<void> _searchMovies() async {
    try {
      var filter = <String, dynamic>{};
      
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
      });
    } catch (e) {
      print('Error searching movies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen("Movies",
      Padding(
        padding: const EdgeInsets.all(32.0),
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
                labelText: "Search",
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
            label: const Text('Search'),
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
                                  labelText: 'Director',
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _genresController,
                                decoration: InputDecoration(
                                  labelText: 'Genre IDs (e.g., 1,2,3)',
                                  hintText: 'Enter genre IDs separated by commas',
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
                                        labelText: 'Min Duration',
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
                                        labelText: 'Max Duration',
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
                                        labelText: 'Min Grade',
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
                                        labelText: 'Max Grade',
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
                                  labelText: 'Release Year',
                                  border: roundedBorder,
                                  enabledBorder: roundedBorder,
                                  focusedBorder: roundedBorder,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text('Is Active'),
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
                            setState(() => localIsActive = true);
                          },
                          child: const Text('Reset'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _searchMovies();
                            Navigator.pop(context);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_alt_outlined),
            label: const Text('Filters'),
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
                  builder: (context) => const EditMovieScreen(),
                ),
              );
              
              // Refresh movies list if new movie was created
              if (result == true) {
                await _loadMovies();
              }
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Movie'),
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
    if (result == null) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Loading movies...",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    if (result!.result.isEmpty) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "No movies found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                "Try adjusting your search criteria",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: result!.result.length,
          itemBuilder: (context, index) {
            final movie = result!.result[index];
            return _buildMovieCard(movie);
          },
        ),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
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
                          Colors.grey[200]!,
                          Colors.grey[300]!,
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
                              Icon(Icons.movie, size: 48, color: Colors.grey[500]),
                              const SizedBox(height: 8),
                              Text(
                                "No Image",
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
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
                        movie.isActive == true ? "Active" : "Inactive",
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
                      movie.title ?? "Unknown Title",
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
                      movie.director ?? "Unknown Director",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.blue[200]!, width: 0.5),
                                ),
                                child: Text(
                                  genre.name ?? "Unknown",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[700],
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
                              Icon(Icons.access_time, size: 10, color: Colors.grey[500]),
                              const SizedBox(width: 2),
                              Text(
                                "${movie.durationMinutes}m",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
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
}