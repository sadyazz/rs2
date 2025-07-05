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
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';

class EditMovieScreen extends StatefulWidget {
  Movie? movie;
  EditMovieScreen({super.key, this.movie});

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
        'isActive': widget.movie!.isActive ?? true,
      };   
    }

    initForm();
  }

    Future initForm() async {
    genresResult = await genreProvider.get();
    actorsResult = await actorProvider.get();

    print("genresResult: ${genresResult?.items}");
    print("actorsResult: ${actorsResult?.items}");

    if (widget.movie != null) {
      if (widget.movie!.genres != null && widget.movie!.genres!.isNotEmpty) {
        _initialValue['genreId'] = widget.movie!.genres!.first.id?.toString();
      }
      
      if (widget.movie!.actors != null && widget.movie!.actors!.isNotEmpty) {
        _initialValue['actorId'] = widget.movie!.actors!.first.id?.toString();
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(l10n.editMovie, Column(
      children:[
        isLoading ? Container() : _buildForm(),
        _save()
      ],
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
                        decoration: InputDecoration(labelText: l10n.title),
                        name: 'title',
                      ),
                      
                      SizedBox(height: 16),
                      
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: l10n.description),
                        name: "description",
                      ),
                      
                      SizedBox(height: 16),
                      
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: l10n.director),
                        name: 'director',
                      ),
                      
                      SizedBox(height: 16),
                      
                      FormBuilderTextField(
                        decoration: InputDecoration(labelText: l10n.durationMinutes),
                        name: 'durationMinutes',
                        keyboardType: TextInputType.number,
                      ),
                      
                      SizedBox(height: 16),
                      
                      FormBuilderDropdown(
                        name:"genreId",
                        decoration: InputDecoration(labelText: l10n.genre),
                        items: genresResult?.items?.map((e)=>DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""),)).toList() ?? [],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            Row(children: [
              Expanded(child: FormBuilderDropdown(
                name:"actorId",
                decoration: InputDecoration(labelText: l10n.actor),
                items: actorsResult?.items?.map((e) => DropdownMenuItem(
                  value: e.id.toString(), 
                  child: Text("${e.firstName ?? ""} ${e.lastName ?? ""}")
                )).toList() ?? [],
              )),
            ],),
            
            SizedBox(height: 16),
            
            Row(children: [
              Expanded(child: FormBuilderDateTimePicker(
                decoration: InputDecoration(labelText: l10n.releaseDate),
                name: 'releaseDate',
                inputType: InputType.date,
              )),
              SizedBox(width:10),
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: l10n.releaseYear),
                name: 'releaseYear',
                keyboardType: TextInputType.number,
              ))
            ],),
            
            SizedBox(height: 16),
            
            Row(children: [
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: l10n.trailerUrl),
                name: 'trailerUrl',
              )),
            ],),
            
            SizedBox(height: 16),
            
            FormBuilderSwitch(
              name: 'isActive',
              title: Text(l10n.isActive),
              decoration: InputDecoration(
                labelText: l10n.movieStatus,
              ),
            ),
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
                _formKey.currentState?.saveAndValidate();
                
                try {
                  var formData = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
                  
                  if (formData['genreId'] != null) {
                    formData['genreIds'] = [int.parse(formData['genreId'])];
                    formData.remove('genreId');
                  }
                  
                  if (formData['actorId'] != null) {
                    formData['actorIds'] = [int.parse(formData['actorId'])];
                    formData.remove('actorId');
                  }
                  
                  if (formData['durationMinutes'] != null && formData['durationMinutes'].toString().isNotEmpty) {
                    formData['durationMinutes'] = int.parse(formData['durationMinutes']);
                  }
                  
                  if (formData['releaseYear'] != null && formData['releaseYear'].toString().isNotEmpty) {
                    formData['releaseYear'] = int.parse(formData['releaseYear']);
                  }
                  
                  if (formData['releaseDate'] != null && formData['releaseDate'] is DateTime) {
                    formData['releaseDate'] = formData['releaseDate'].toIso8601String();
                  }
                  
                  formData['isActive'] = formData['isActive'] ?? true;

                  if (_imageBase64 != null) {
                    formData['image'] = _imageBase64;
                  }
                  
                  if(widget.movie == null){
                    await movieProvider.insert(formData);
                  }else{
                    await movieProvider.update(widget.movie!.id!, formData);
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