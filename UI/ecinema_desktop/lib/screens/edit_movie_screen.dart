import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/genre.dart';
import 'package:ecinema_desktop/models/actor.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/movie_provider.dart';
import 'package:ecinema_desktop/providers/genre_provider.dart';
import 'package:ecinema_desktop/providers/actor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

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
    return MasterScreen('Edit Movie', Column(
      children:[
        isLoading ? Container() : _buildForm(),
        _save()
      ],
    ), showDrawer: false);
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          children: [
            Row(children: [
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Title'),
                name: 'title',
              )),
              SizedBox(width:10),
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Description'),
                name:"description",
              ))
            ],),
            
            SizedBox(height: 16),
            
            Row(children: [
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Director'),
                name: 'director',
              )),
              SizedBox(width:10),
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                name: 'durationMinutes',
                keyboardType: TextInputType.number,
              ))
            ],),
            
            SizedBox(height: 16),
            
            Row(children: [
              Expanded(child: FormBuilderDropdown(
                name:"genreId",
                decoration: InputDecoration(labelText: 'Genre'),
                items: genresResult?.items?.map((e)=>DropdownMenuItem(value: e.id.toString(), child: Text(e.name ?? ""),)).toList() ?? [],
              )),
              SizedBox(width:10),
              Expanded(child: FormBuilderDropdown(
                name:"actorId",
                decoration: InputDecoration(labelText: 'Actor'),
                items: actorsResult?.items?.map((e) => DropdownMenuItem(
                  value: e.id.toString(), 
                  child: Text("${e.firstName ?? ""} ${e.lastName ?? ""}")
                )).toList() ?? [],
              )),
            ],),
            
            SizedBox(height: 16),
            
            Row(children: [
              Expanded(child: FormBuilderDateTimePicker(
                decoration: InputDecoration(labelText: 'Release Date'),
                name: 'releaseDate',
                inputType: InputType.date,
              )),
              SizedBox(width:10),
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Release Year'),
                name: 'releaseYear',
                keyboardType: TextInputType.number,
              ))
            ],),
            
            SizedBox(height: 16),
            
            Row(children: [
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Trailer URL'),
                name: 'trailerUrl',
              )),
              SizedBox(width:10),
              Expanded(child: FormBuilderTextField(
                decoration: InputDecoration(labelText: 'Image URL'),
                name: 'image',
              ))
            ],),
            
            SizedBox(height: 16),
            
            FormBuilderSwitch(
              name: 'isActive',
              title: Text('Is Active'),
              decoration: InputDecoration(
                labelText: 'Movie Status',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _save() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children:[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
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
                  
                  print('Form data to send: $formData');
                  
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
                      content: Text('Error saving movie: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text(widget.movie == null ? 'Add Movie' : 'Update Movie'),
          ),
        ]
      ),
    );
  }
  

}