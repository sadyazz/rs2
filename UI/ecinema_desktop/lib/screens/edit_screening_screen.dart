import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/screening.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/hall.dart';
import 'package:ecinema_desktop/models/screening_format.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/providers/screening_provider.dart';
import 'package:ecinema_desktop/providers/movie_provider.dart';
import 'package:ecinema_desktop/providers/hall_provider.dart';
import 'package:ecinema_desktop/providers/screening_format_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class EditScreeningScreen extends StatefulWidget {
  final Screening? screening;

  const EditScreeningScreen({super.key, this.screening});

  @override
  State<EditScreeningScreen> createState() => _EditScreeningScreenState();
}

class _EditScreeningScreenState extends State<EditScreeningScreen> {
  late ScreeningProvider provider;
  late MovieProvider movieProvider;
  late HallProvider hallProvider;
  late ScreeningFormatProvider formatProvider;
  Screening? currentScreening;
  
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  bool isLoading = false;
  bool isLoadingData = true;

  SearchResult<Movie>? moviesResult;
  SearchResult<Hall>? hallsResult;
  SearchResult<ScreeningFormat>? formatsResult;
  


  @override
  void initState() {
    super.initState();
    currentScreening = widget.screening;
    
    provider = Provider.of<ScreeningProvider>(context, listen: false);
    movieProvider = Provider.of<MovieProvider>(context, listen: false);
    hallProvider = Provider.of<HallProvider>(context, listen: false);
    formatProvider = Provider.of<ScreeningFormatProvider>(context, listen: false);

    if (widget.screening != null) {
      _initialValue = {
        'movieId': widget.screening!.movieId,
        'hallId': widget.screening!.hallId,
        'screeningFormatId': widget.screening!.screeningFormatId ?? 0,
        'language': widget.screening!.language,
        'basePrice': widget.screening!.basePrice?.toString(),
        'startTime': widget.screening!.startTime,
        'endTime': widget.screening!.endTime,
        'hasSubtitles': widget.screening!.hasSubtitles ?? false,
        'isActive': widget.screening!.isActive ?? true,
      };
    }

    initForm();
  }

  Future initForm() async {
    try {
      var movieFilter = <String, dynamic>{
        'isActive': true,
        'isDeleted': false,
      };
      var hallFilter = <String, dynamic>{
        'isActive': true,
        'isDeleted': false,
      };
      var formatFilter = <String, dynamic>{
        'isActive': true,
        'isDeleted': false,
      };

      moviesResult = await movieProvider.get(filter: movieFilter);
      hallsResult = await hallProvider.get(filter: hallFilter);
      formatsResult = await formatProvider.get(filter: formatFilter);

      if (widget.screening?.id != null) {
        try {
          final fullScreening = await provider.getById(widget.screening!.id!);
          if (fullScreening != null) {
            currentScreening = fullScreening;
            _initialValue = {
              'movieId': fullScreening.movieId,
              'hallId': fullScreening.hallId,
              'screeningFormatId': fullScreening.screeningFormatId ?? 0,
              'language': fullScreening.language,
              'basePrice': fullScreening.basePrice?.toString(),
              'startTime': fullScreening.startTime,
              'endTime': fullScreening.endTime,
              'hasSubtitles': fullScreening.hasSubtitles ?? false,
              'isActive': fullScreening.isActive ?? true,
            };
          }
        } catch (e) {
          print('Error loading full screening data: $e');
        }
      }

      setState(() {
        isLoadingData = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoadingData = false;
      });
    }
  }

  Future<void> _saveScreening() async {
    final l10n = AppLocalizations.of(context)!;
    
    _formKey.currentState?.saveAndValidate();
    
    setState(() {
      isLoading = true;
    });

    try {
      var formData = Map<String, dynamic>.from(_formKey.currentState?.value ?? {});
      
      if (formData['basePrice'] != null && formData['basePrice'].toString().isNotEmpty) {
        formData['basePrice'] = double.tryParse(formData['basePrice']);
      }
      
      if (formData['movieId'] != null) {
        formData['movieId'] = int.parse(formData['movieId'].toString());
      }
      
      if (formData['hallId'] != null) {
        formData['hallId'] = int.parse(formData['hallId'].toString());
      }
      
      if (formData['screeningFormatId'] != null && formData['screeningFormatId'] != 0) {
        formData['screeningFormatId'] = int.parse(formData['screeningFormatId'].toString());
      } else {
        formData['screeningFormatId'] = null;
      }
      
      if (formData['startTime'] != null && formData['startTime'] is DateTime) {
        formData['startTime'] = formData['startTime'].toIso8601String();
      }
      
      if (formData['endTime'] != null && formData['endTime'] is DateTime) {
        formData['endTime'] = formData['endTime'].toIso8601String();
      }

      formData['hasSubtitles'] = formData['hasSubtitles'] ?? false;
      formData['isActive'] = formData['isActive'] ?? true;

      if (widget.screening?.id != null) {
        await provider.update(widget.screening!.id!, formData);
      } else {
        await provider.insert(formData);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.screening?.id != null 
            ? l10n.screeningUpdatedSuccessfully
            : l10n.screeningCreatedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print('Error saving screening: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToSaveScreening),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MasterScreen(
      widget.screening?.id != null 
        ? '${l10n.editScreening} - ${widget.screening!.movieTitle}' 
        : l10n.addScreening,
      Column(
        children: [
          isLoadingData ? const Center(child: CircularProgressIndicator()) : _buildForm(),
          _save(),
        ],
      ),
      showDrawer: false,
    );
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
              children: [
                Expanded(
                  child: FormBuilderDropdown<int>(
                    name: 'movieId',
                    decoration: InputDecoration(
                      labelText: l10n.movie,
                      border: const OutlineInputBorder(),
                    ),
                    items: moviesResult?.items?.map((movie) => DropdownMenuItem(
                      value: movie.id,
                      child: Text(movie.title ?? l10n.unknownMovie),
                    )).toList() ?? [],
                    validator: (value) {
                      if (value == null) {
                        return l10n.pleaseSelectMovie;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormBuilderDropdown<int>(
                    name: 'hallId',
                    decoration: InputDecoration(
                      labelText: l10n.hall,
                      border: const OutlineInputBorder(),
                    ),
                    items: hallsResult?.items?.map((hall) => DropdownMenuItem(
                      value: hall.id,
                      child: Text(hall.name ?? l10n.unknownHall),
                    )).toList() ?? [],
                    validator: (value) {
                      if (value == null) {
                        return l10n.pleaseSelectHall;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown<int>(
                    name: 'screeningFormatId',
                    decoration: InputDecoration(
                      labelText: l10n.screeningFormatOptional,
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text(l10n.none),
                      ),
                      ...(formatsResult?.items?.map((format) => DropdownMenuItem(
                        value: format.id,
                        child: Text(format.name ?? l10n.unknownFormat),
                      )).toList() ?? []),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'language',
                    decoration: InputDecoration(
                      labelText: l10n.language,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterLanguage;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'basePrice',
                    decoration: InputDecoration(
                      labelText: l10n.basePrice,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.pleaseEnterBasePrice;
                      }
                      if (double.tryParse(value) == null) {
                        return l10n.pleaseEnterValidNumber;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormBuilderDateTimePicker(
                    name: 'startTime',
                    decoration: InputDecoration(
                      labelText: l10n.startTime,
                      border: const OutlineInputBorder(),
                    ),
                    inputType: InputType.both,
                    format: DateFormat('yyyy-MM-dd HH:mm'),
                    validator: (value) {
                      if (value == null) {
                        return l10n.pleaseEnterStartTime;
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderDateTimePicker(
              name: 'endTime',
              decoration: InputDecoration(
                labelText: l10n.endTime,
                border: const OutlineInputBorder(),
              ),
              inputType: InputType.both,
              format: DateFormat('yyyy-MM-dd HH:mm'),
              validator: (value) {
                if (value == null) {
                  return l10n.pleaseEnterEndTime;
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            FormBuilderSwitch(
              name: 'hasSubtitles',
              title: Text(l10n.hasSubtitles),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderSwitch(
              name: 'isActive',
              title: Text(l10n.isActive),
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
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: isLoading ? null : _saveScreening,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(widget.screening?.id != null ? l10n.update : l10n.create),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
