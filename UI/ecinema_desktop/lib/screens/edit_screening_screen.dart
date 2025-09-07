import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/screening.dart';
import 'package:ecinema_desktop/models/movie.dart';
import 'package:ecinema_desktop/models/hall.dart';
import 'package:ecinema_desktop/models/screening_format.dart';
import 'package:ecinema_desktop/models/search_result.dart';
import 'package:ecinema_desktop/models/seat.dart';
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
  bool isLoadingSeats = false;
  
  SearchResult<Movie>? moviesResult;
  SearchResult<Hall>? hallsResult;
  SearchResult<ScreeningFormat>? formatsResult;
  
  List<Seat> seats = [];

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
      };
    }

    initForm();
  }

  Future initForm() async {
    try {
      var movieFilter = <String, dynamic>{
        'isDeleted': false,
        'isComingSoon': false,
      };
      var hallFilter = <String, dynamic>{
        'isDeleted': false,
      };
      var formatFilter = <String, dynamic>{
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

            };
          }
          
          await _loadSeats();
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

  Future<void> _loadSeats() async {
    if (widget.screening?.id == null) {
      return;
    }
    
    setState(() {
      isLoadingSeats = true;
    });

    try {
      final seatsList = await provider.getSeatsForScreening(widget.screening!.id!);
      
      setState(() {
        seats = seatsList;
      });
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading seats: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoadingSeats = false;
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
      

      if (widget.screening?.id != null) {
        await provider.update(widget.screening!.id!, formData);
      } else {
        final screening = await provider.insert(formData);
        await provider.generateSeatsForScreening(screening.id!);
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
      String errorMessage = l10n.failedToSaveScreening;
      
      if (e.toString().contains("End time must be after start time")) {
        errorMessage = l10n.endTimeMustBeAfterStartTime;
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
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
      SingleChildScrollView(
        child: Column(
          children: [
            isLoadingData ? const Center(child: CircularProgressIndicator()) : _buildForm(),
            if (widget.screening?.id != null) ...[
              const SizedBox(height: 24),
              _buildSeatsOverview(),
            ],
            _save(),
          ],
        ),
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
                
                final startTime = _formKey.currentState?.fields['startTime']?.value as DateTime?;
                if (startTime != null && value.isBefore(startTime)) {
                  return l10n.endTimeMustBeAfterStartTime;
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
            
            
          ],
        ),
      ),
    );
  }

  Widget _buildSeatsOverview() {
    final l10n = AppLocalizations.of(context)!;
    
    if (isLoadingSeats) {
      return const Center(child: CircularProgressIndicator());
    }

    final reservedSeats = seats.where((seat) => seat.isReserved == true).length;
    final totalSeats = seats.length;
    final availableSeats = totalSeats - reservedSeats;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event_seat,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Seats Overview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _loadSeats,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh seats',
                  ),
                  if (seats.isEmpty) ...[
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await provider.generateSeatsForScreening(widget.screening!.id!);
                          await _loadSeats();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Seats generated successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to generate seats: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Generate Seats'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  _buildSeatStatCard(
                    l10n.totalSeats,
                    totalSeats.toString(),
                    Icons.event_seat,
                    Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  _buildSeatStatCard(
                    l10n.availableSeats,
                    availableSeats.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                  const SizedBox(width: 12),
                  _buildSeatStatCard(
                    l10n.reservedSeats,
                    reservedSeats.toString(),
                    Icons.block,
                    Colors.red,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Seat Layout',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              _buildSeatsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatsGrid() {
    final l10n = AppLocalizations.of(context)!;
    
    if (seats.isEmpty) {
      return const Center(
        child: Text('No seats available'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'SCREEN',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Container(
            height: 300,
            child: SingleChildScrollView(
              child: _buildSeatsGridContent(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSeatLegend(l10n.available, Colors.green),
              const SizedBox(width: 24),
              _buildSeatLegend(l10n.reserved, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatsGridContent() {
    if (seats.isEmpty) {
      return const Center(
        child: Text('No seats available'),
      );
    }

    return _buildRowLayout();
  }

  Widget _buildRowLayout() {
    if (seats.isEmpty) {
      return const Center(child: Text('No seats available'));
    }

    final Map<String, List<Seat>> rows = {};
    
    for (final seat in seats) {
      final seatName = seat.name ?? '';
      if (seatName.isNotEmpty) {
        final row = seatName[0];
        if (!rows.containsKey(row)) {
          rows[row] = [];
        }
        rows[row]!.add(seat);
      }
    }

    final sortedRows = rows.keys.toList()..sort();

    return Column(
      children: sortedRows.map((row) => _buildSeatRow(row, rows[row]!)).toList(),
    );
  }

  Widget _buildSeatRow(String rowName, List<Seat> rowSeats) {
    final sortedSeats = rowSeats.toList()
      ..sort((a, b) {
        final aName = a.name ?? '';
        final bName = b.name ?? '';
        if (aName.length > 1 && bName.length > 1) {
          return int.parse(aName.substring(1)).compareTo(int.parse(bName.substring(1)));
        }
        return aName.compareTo(bName);
      });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 25,
            child: Text(
              rowName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 6),
          ...sortedSeats.map((seat) => _buildSeatItem(seat)),
        ],
      ),
    );
  }

  Widget _buildSeatItem(Seat seat) {
    final isReserved = seat.isReserved ?? false;
    final seatName = seat.name ?? 'Unknown';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 1),
      child: Tooltip(
        message: '$seatName - ${isReserved ? "Reserved" : "Available"}',
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isReserved ? Colors.red : Colors.green,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isReserved ? Colors.red.shade700 : Colors.green.shade700,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              seatName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeatLegend(String label, Color color, {bool isLayout = false}) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isLayout ? Colors.transparent : color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: color,
              width: isLayout ? 2 : 1,
            ),
          ),
          child: isLayout ? Center(
            child: Icon(
              Icons.grid_on,
              size: 12,
              color: color,
            ),
          ) : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
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
