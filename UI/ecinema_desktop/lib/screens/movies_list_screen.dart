import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/movie_provider.dart';
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
                print(result?.result[0].title);

                setState(() {
                  result = result;
                });
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
      ],
    );
  }

  Widget _BuildResultView(){
    if (result == null || result!.result.isEmpty) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.movie_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "Search for movies to get started",
                style: TextStyle(fontSize: 18, color: Colors.grey),
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
            crossAxisCount: 4,
            childAspectRatio: 0.75,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 6),
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
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.movie, size: 56, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        "No Image",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: movie.isActive == true ? Colors.green[600] : Colors.red[600],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      movie.isActive == true ? "Active" : "Inactive",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title ?? "Unknown Title",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.director ?? "Unknown Director",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (movie.genres != null && movie.genres!.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: movie.genres!.take(2).map((genre) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          genre.name ?? "Unknown",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        movie.grade?.toStringAsFixed(1) ?? "N/A",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: IconButton(
                          onPressed: () {
                            // TODO: Implement edit functionality
                            print('Edit movie: ${movie.title}');
                          },
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.blue[600],
                          ),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        child: IconButton(
                          onPressed: () {
                            // TODO: Implement delete functionality
                            print('Delete movie: ${movie.title}');
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.red[600],
                          ),
                          padding: const EdgeInsets.all(6),
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
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
    );
  }
}