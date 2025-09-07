import 'dart:io';

import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/genre.dart';
import 'package:ecinema_desktop/models/actor.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/movie_provider.dart';
import 'package:ecinema_desktop/providers/genre_provider.dart';
import 'package:ecinema_desktop/providers/actor_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';

class EditMovieScreen extends StatefulWidget {
  final Movie? movie;
  const EditMovieScreen({super.key, this.movie});

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();  
}

class _EditMovieScreenState extends State<EditMovieScreen> {

  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  late MovieProvider movieProvider;
  late GenreProvider genreProvider;
  late ActorProvider actorProvider;

  SearchResult<Genre>? genresResult;
  SearchResult<Actor>? actorsResult;  

  bool isLoading = true;
  bool isComingSoon = false;

  List<Genre> _selectedGenres = [];
  List<Actor> _selectedActors = [];
  TextEditingController _genreSearchController = TextEditingController();
  TextEditingController _actorSearchController = TextEditingController();
  TextEditingController _releaseYearController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    
  }

  @override
  void initState() {
    super.initState();

    movieProvider = Provider.of<MovieProvider>(context, listen: false);
    genreProvider = Provider.of<GenreProvider>(context, listen: false);
    actorProvider = Provider.of<ActorProvider>(context, listen: false);

    if (widget.movie != null) {
      _initialValue = {
        'title': widget.movie!.title,
        'description': widget.movie!.description,
        'director': widget.movie!.director,
        'durationMinutes': widget.movie!.durationMinutes?.toString(),
        'releaseYear': widget.movie!.releaseYear?.toString(),
        'releaseDate': widget.movie!.releaseDate,
        'trailerUrl': widget.movie!.trailerUrl,
        'image': widget.movie!.image,
        'isComingSoon': widget.movie!.isComingSoon ?? false,
      };
      isComingSoon = widget.movie!.isComingSoon ?? false;
      
      if (widget.movie!.releaseYear != null) {
        _releaseYearController.text = widget.movie!.releaseYear!.toString();
      }
    }

    initForm();
  }

  @override
  void dispose() {
    _genreSearchController.dispose();
    _actorSearchController.dispose();
    _releaseYearController.dispose();
    super.dispose();
  }

    Future initForm() async {
    genresResult = await genreProvider.get();
    actorsResult = await actorProvider.get();



    if (widget.movie != null) {
      if (widget.movie!.genres != null && widget.movie!.genres!.isNotEmpty) {
        _selectedGenres = List.from(widget.movie!.genres!);
      }
      
      if (widget.movie!.actors != null && widget.movie!.actors!.isNotEmpty) {
        _selectedActors = List.from(widget.movie!.actors!);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(widget.movie?.id != null 
        ? '${l10n.editMovie} - ${widget.movie!.title}' 
        : l10n.addMovie, SingleChildScrollView(
      child: Column(
        children:[
          isLoading ? Container() : _buildForm(),
          _save()
        ],
      ),
    ), showDrawer: false);
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.image,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Movie Poster',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: (_initialValue['image'] != null && _initialValue['image'].toString().isNotEmpty) || _imageBase64 != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          base64Decode(_imageBase64 ?? _initialValue['image']),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      )
                                    : MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: getImage,
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.movie,
                                                  size: 48,
                                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Select movie',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 24),
                
                Expanded(
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'title',
                        decoration: InputDecoration(
                          labelText: l10n.title,
                          border: const OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: l10n.pleaseEnterMovieTitle),
                          FormBuilderValidators.maxLength(200, errorText: l10n.movieTitleTooLong),
                        ]),
                      ),
                      
                      SizedBox(height: 16),
                      
                      FormBuilderTextField(
                        name: 'description',
                        decoration: InputDecoration(
                          labelText: l10n.description,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: l10n.pleaseEnterMovieDescription),
                          FormBuilderValidators.maxLength(1000, errorText: l10n.movieDescriptionTooLong),
                        ]),
                      ),
                      
                      SizedBox(height: 16),
                      
                      FormBuilderTextField(
                        name: 'director',
                        decoration: InputDecoration(
                          labelText: l10n.director,
                          border: const OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: l10n.pleaseEnterMovieDirector),
                          FormBuilderValidators.maxLength(100, errorText: l10n.movieDirectorTooLong),
                        ]),
                      ),
                      
                      SizedBox(height: 16),
                      
                      FormBuilderTextField(
                        name: 'durationMinutes',
                        decoration: InputDecoration(
                          labelText: l10n.durationMinutes,
                          border: const OutlineInputBorder(),
                          helperText: l10n.durationMinutesHelp,
                        ),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: l10n.pleaseEnterMovieDuration),
                          FormBuilderValidators.numeric(errorText: l10n.pleaseEnterValidNumber),
                          FormBuilderValidators.min(1, errorText: l10n.movieDurationTooShort),
                          FormBuilderValidators.max(600, errorText: l10n.movieDurationTooLong),
                        ]),
                      ),
                      
                      SizedBox(height: 16),
                      
                      Row(children: [
                        Expanded(child: FormBuilderDateTimePicker(
                          name: 'releaseDate',
                          decoration: InputDecoration(
                            labelText: l10n.releaseDate,
                            border: const OutlineInputBorder(),
                          ),
                          inputType: InputType.date,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(errorText: l10n.pleaseEnterReleaseDate),
                          ]),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _initialValue['releaseYear'] = value.year.toString();
                                _releaseYearController.text = value.year.toString();
                              });
                            }
                          },
                        )),
                        const SizedBox(width:10),
                        Expanded(child: TextField(
                          controller: _releaseYearController,
                          decoration: InputDecoration(labelText: l10n.releaseYear),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final year = int.tryParse(value);
                            if (year != null) {
                              if (year < 1888 || year > DateTime.now().year + 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.invalidReleaseYear),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ))
                      ],),
                      
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            _buildSearchableDropdown(
              label: l10n.genre,
              items: genresResult?.items ?? [],
              selectedItems: _selectedGenres,
              onItemSelected: (genre) {
                setState(() {
                  if (!_selectedGenres.contains(genre)) {
                    _selectedGenres.add(genre);
                  }
                });
              },
              onItemRemoved: (genre) {
                setState(() {
                  _selectedGenres.remove(genre);
                });
              },
              itemToString: (genre) => genre.name ?? "",
            ),
            
            const SizedBox(height: 16),
            
            Row(children: [
              Expanded(child: _buildSearchableDropdown(
                label: l10n.actor,
                items: actorsResult?.items ?? [],
                selectedItems: _selectedActors,
                onItemSelected: (actor) {
                  setState(() {
                    if (!_selectedActors.contains(actor)) {
                      _selectedActors.add(actor);
                    }
                  });
                },
                onItemRemoved: (actor) {
                  setState(() {
                    _selectedActors.remove(actor);
                  });
                },
                itemToString: (actor) => "${actor.firstName ?? ""} ${actor.lastName ?? ""}",
              )),
            ],),
            
            const SizedBox(height: 16),
            
                      Row(children: [
                        Expanded(child: FormBuilderTextField(
                          name: 'trailerUrl',
                          decoration: InputDecoration(
                            labelText: l10n.trailerUrl,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return null; 
                            }
                            final uri = Uri.tryParse(value);
                            if (uri == null || !uri.hasAbsolutePath) {
                              return l10n.pleaseEnterValidUrl;
                            }
                            return null;
                          },
                        )),
                      ],),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Text(
                  l10n.comingSoon,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: isComingSoon,
                  onChanged: (value) {
                    setState(() {
                      isComingSoon = value;
                    });
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),

          ],
        ),
      ),
    );
  }
  
  Widget _save() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children:[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(l10n.cancel),
          ),
          SizedBox(width: 16),
          ElevatedButton(
            onPressed:() async {
                if (!_formKey.currentState!.saveAndValidate()) {
                  return;
                }

                if (_selectedGenres.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.pleaseSelectAtLeastOneGenre),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (_selectedActors.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.pleaseSelectAtLeastOneActor),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                
                try {
                  var formData = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
                  
                  if (formData['genreIds'] != null) {
                    formData['genreIds'] = formData['genreIds'].map((id) => int.parse(id)).toList();
                  }
                  
                  if (formData['actorIds'] != null) {
                    formData['actorIds'] = formData['actorIds'].map((id) => int.parse(id)).toList();
                  }
                  
                  formData['genreIds'] = _selectedGenres.map((g) => g.id).toList();
                  formData['actorIds'] = _selectedActors.map((a) => a.id).toList();
                  
                  if (formData['durationMinutes'] != null && formData['durationMinutes'].toString().isNotEmpty) {
                    formData['durationMinutes'] = int.parse(formData['durationMinutes']);
                  }
                  
                  if (formData['releaseYear'] != null && formData['releaseYear'].toString().isNotEmpty) {
                    formData['releaseYear'] = int.parse(formData['releaseYear']);
                  }
                  
                  if (_releaseYearController.text.isNotEmpty) {
                    formData['releaseYear'] = int.parse(_releaseYearController.text);
                  }
                  
                  if (formData['releaseDate'] != null && formData['releaseDate'] is DateTime) {
                    formData['releaseDate'] = formData['releaseDate'].toIso8601String();
                  }
                  
                  formData['isComingSoon'] = isComingSoon;
                  
                  if (_imageBase64 != null) {
                    formData['image'] = _imageBase64;
                  }
                  
                  if(widget.movie == null){
                    await movieProvider.insert(formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.movieCreatedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }else{
                    await movieProvider.update(widget.movie!.id!, formData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.movieUpdatedSuccessfully),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  
                  Navigator.of(context).pop(true);
                } catch (e) {
                  print('Error saving movie: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.errorSavingMovie(e.toString())),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(widget.movie == null ? l10n.addMovie : l10n.updateMovie),
          ),
        ]
      ),
    );
  }

  Widget _buildSearchableDropdown<T>({
    required String label,
    required List<T> items,
    required List<T> selectedItems,
    required Function(T) onItemSelected,
    required Function(T) onItemRemoved,
    required String Function(T) itemToString,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: label == l10n.genre ? _genreSearchController : _actorSearchController,
          decoration: InputDecoration(
            labelText: label,
            hintText: 'Search ${label.toLowerCase()}...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
            suffixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        if ((label == l10n.genre ? _genreSearchController.text : _actorSearchController.text).isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
            ),
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.where((item) => 
                itemToString(item).toLowerCase().contains(
                  (label == l10n.genre ? _genreSearchController.text : _actorSearchController.text).toLowerCase()
                )
              ).length,
              itemBuilder: (context, index) {
                final filteredItems = items.where((item) => 
                  itemToString(item).toLowerCase().contains(
                    (label == l10n.genre ? _genreSearchController.text : _actorSearchController.text).toLowerCase()
                  )
                ).toList();
                final item = filteredItems[index];
                final isSelected = selectedItems.contains(item);
                
                return ListTile(
                  title: Text(itemToString(item)),
                  trailing: isSelected ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                  onTap: () {
                    if (isSelected) {
                      onItemRemoved(item);
                    } else {
                      onItemSelected(item);
                    }
                    if (label == l10n.genre) {
                      _genreSearchController.clear();
                    } else {
                      _actorSearchController.clear();
                    }
                    setState(() {});
                  },
                );
              },
            ),
          ),
        if (selectedItems.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: selectedItems.map((item) => Chip(
              label: Text(itemToString(item)),
              deleteIcon: Icon(Icons.close, size: 18),
              onDeleted: () => onItemRemoved(item),
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            )).toList(),
          ),
        ],
      ],
    );
  }

  File? _image;
  String? _imageBase64;
  
  void getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if(result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _imageBase64 = base64Encode(_image!.readAsBytesSync());
      setState(() {});
    }
  }
}