import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/hall.dart';
import 'package:ecinema_desktop/models/seat.dart';
import 'package:ecinema_desktop/providers/hall_provider.dart';
import 'package:ecinema_desktop/providers/seat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditHallScreen extends StatefulWidget {
  final Hall? hall;

  const EditHallScreen({super.key, this.hall});

  @override
  State<EditHallScreen> createState() => _EditHallScreenState();
}

class _EditHallScreenState extends State<EditHallScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  List<Seat> _seats = [];
  bool _isLoadingSeats = false;

  @override
  void initState() {
    super.initState();
    if (widget.hall?.id != null) {
      _loadSeats();
    } else {
      print('No hall ID, skipping seat loading');
    }
  }

  Future<void> _loadSeats() async {
    if (widget.hall?.id == null) return;
    
    setState(() {
      _isLoadingSeats = true;
    });

    try {
      final seatProvider = Provider.of<SeatProvider>(context, listen: false);
      final seats = await seatProvider.getByHallId(widget.hall!.id!);
      setState(() {
        _seats = seats;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load seats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSeats = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.hall != null;
    
    return MasterScreen(
      isEditing ? l10n.editHall : l10n.addNewHall,
      SingleChildScrollView(
        child: Column(
          children: [
            _buildForm(l10n, isEditing),
            if (isEditing) _buildSeatsSection(l10n),
            _save(l10n, isEditing),
          ],
        ),
      ),
      showDrawer: false,
    );
  }

  Widget _buildForm(AppLocalizations l10n, bool isEditing) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: {
          'name': widget.hall?.name ?? '',
          'location': widget.hall?.location ?? '',
          'capacity': (widget.hall?.capacity ?? 1).toString(),
          'screenType': widget.hall?.screenType ?? '',
          'soundSystem': widget.hall?.soundSystem ?? '',
        },
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'name',
              decoration: InputDecoration(
                labelText: l10n.hallName,
                border: const OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterHallName),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'location',
              decoration: InputDecoration(
                labelText: l10n.hallLocation,
                border: const OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterHallLocation),
              ]),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'capacity',
              decoration: InputDecoration(
                labelText: l10n.hallCapacity,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.auto_fix_high),
                  tooltip: l10n.autoGenerateSeatsTooltip,
                  onPressed: () => _showAutoGenerateSeatsDialog(l10n),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterHallCapacity),
                FormBuilderValidators.min(1, errorText: l10n.capacityMustBeAtLeastOne),
              ]),
              onChanged: (value) {
                setState(() {});
              },
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'screenType',
              decoration: InputDecoration(
                labelText: l10n.hallScreenType,
                border: const OutlineInputBorder(),
                hintText: l10n.screenTypeHint,
              ),
            ),
            
            const SizedBox(height: 16),
            
            FormBuilderTextField(
              name: 'soundSystem',
              decoration: InputDecoration(
                labelText: l10n.hallSoundSystem,
                border: const OutlineInputBorder(),
                hintText: l10n.soundSystemHint,
              ),
            ),
            
            const SizedBox(height: 16),
            

          ],
        ),
      ),
    );
  }

  Widget _save(AppLocalizations l10n, bool isEditing) {
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
            onPressed: _isLoading ? null : _saveHall,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(isEditing ? l10n.update : l10n.create),
          ),
        ],
      ),
    );
  }

  Future<void> _saveHall() async {
    final l10n = AppLocalizations.of(context)!;
    
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final formData = _formKey.currentState!.value;
        final hallProvider = Provider.of<HallProvider>(context, listen: false);
        
        final hall = Hall(
          id: widget.hall?.id,
          name: formData['name'],
          location: formData['location'],
          capacity: int.tryParse(formData['capacity']) ?? 1,
          screenType: formData['screenType'],
          soundSystem: formData['soundSystem'],
        );

        if (widget.hall == null) {
          final savedHall = await hallProvider.insert(hall);
          await _autoGenerateSeatsForNewHall(savedHall.id!, hall.capacity ?? 1);
                } else {
          await hallProvider.update(widget.hall!.id!, hall);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.hallSavedSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.failedToSaveHall),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showAutoGenerateSeatsDialog(AppLocalizations l10n) {
    final actualCapacity = widget.hall?.capacity ?? 1;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.autoGenerateSeats),
        content: Text(
          l10n.autoGenerateSeatsMessage(actualCapacity),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _autoGenerateSeats(actualCapacity);
            },
            child: Text(l10n.generate),
          ),
        ],
      ),
    );
  }

  Future<void> _autoGenerateSeatsForNewHall(int hallId, int capacity) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final seatProvider = Provider.of<SeatProvider>(context, listen: false);
      
      final newSeats = <Seat>[];
      int seatNumber = 1;
      int rowNumber = 1;
      int seatsPerRow = 10;
      
      for (int i = 0; i < capacity; i++) {
        if (seatNumber > seatsPerRow) {
          seatNumber = 1;
          rowNumber++;
        }
        
        final seat = Seat(
          id: null,
          hallId: hallId,
          seatNumber: seatNumber,
          rowNumber: rowNumber,
        );
        
        await seatProvider.insert(seat);
        newSeats.add(seat);
        seatNumber++;
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.seatsGeneratedSuccessfully(capacity)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToGenerateSeats(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _autoGenerateSeats(int? capacity) async {
    final targetCapacity = capacity ?? widget.hall?.capacity ?? 1;
    
    final l10n = AppLocalizations.of(context)!;
    try {
      final seatProvider = Provider.of<SeatProvider>(context, listen: false);
      
      for (final seat in _seats) {
        await seatProvider.delete(seat.id!);
      }
      
      final newSeats = <Seat>[];
      int seatNumber = 1;
      int rowNumber = 1;
      int seatsPerRow = 10;
      
      for (int i = 0; i < targetCapacity; i++) {
        if (seatNumber > seatsPerRow) {
          seatNumber = 1;
          rowNumber++;
        }
        
        final seat = Seat(
          id: null,
          hallId: widget.hall!.id!,
          seatNumber: seatNumber,
          rowNumber: rowNumber,
        );
        
        await seatProvider.insert(seat);
        newSeats.add(seat);
        seatNumber++;
      }
      
      setState(() {
        _seats = newSeats;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.seatsGeneratedSuccessfully(targetCapacity)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.failedToGenerateSeats(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCapacityValidation(AppLocalizations l10n) {
    int currentCapacity = widget.hall?.capacity ?? 0;
    final formState = _formKey.currentState;
    if (formState != null) {
      final dynamic raw = formState.value['capacity'];
      if (raw is String && raw.trim().isNotEmpty) {
        currentCapacity = int.tryParse(raw) ?? currentCapacity;
      } else if (raw is int) {
        currentCapacity = raw;
      }
    }
    final currentSeatCount = _seats.length;
    final isValid = currentSeatCount == currentCapacity;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isValid ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isValid ? Colors.green[200]! : Colors.orange[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.warning,
            color: isValid ? Colors.green[600] : Colors.orange[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isValid 
                ? l10n.seatCountMatchesCapacity(currentSeatCount, currentCapacity)
                : l10n.seatCountMismatch(currentSeatCount, currentCapacity),
              style: TextStyle(
                color: isValid ? Colors.green[700] : Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatsSection(AppLocalizations l10n) {
    final seatsByRow = <int, List<Seat>>{};
    for (final seat in _seats) {
      seatsByRow.putIfAbsent(seat.rowNumber, () => []).add(seat);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.seatsManagement,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddSeatDialog(l10n);
                    },
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addSeat),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildCapacityValidation(l10n),
              const SizedBox(height: 16),
              if (_isLoadingSeats)
                const Center(child: CircularProgressIndicator())
              else if (_seats.isEmpty)
                Center(
                  child: Text(
                    l10n.noSeatsFound,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                _buildSeatsGrid(l10n, seatsByRow),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeatsGrid(AppLocalizations l10n, Map<int, List<Seat>> seatsByRow) {
    final sortedRows = seatsByRow.keys.toList()..sort();
    
    return Column(
      children: sortedRows.map((rowNumber) {
        final rowSeats = seatsByRow[rowNumber]!;
        rowSeats.sort((a, b) => a.seatNumber.compareTo(b.seatNumber));
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(
                  'R$rowNumber',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ...rowSeats.map((seat) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: _buildSeatWidget(seat, l10n),
              )),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeatWidget(Seat seat, AppLocalizations l10n) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _showEditSeatDialog(l10n, seat);
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.green.shade700,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              '${seat.seatNumber}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditSeatDialog(AppLocalizations l10n, Seat seat) {
    final formKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.editSeat),
          content: FormBuilder(
            key: formKey,
            initialValue: {
              'seatNumber': seat.seatNumber.toString(),
              'rowNumber': seat.rowNumber.toString(),
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'seatNumber',
                  decoration: InputDecoration(labelText: 'Seat Number'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please enter seat number'),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'rowNumber',
                  decoration: InputDecoration(labelText: 'Row Number'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please enter row number'),
                  ]),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
                        ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.saveAndValidate() ?? false) {
                  final seatData = formKey.currentState!.value;
                  
                  final updatedSeat = Seat(
                    id: seat.id,
                    hallId: widget.hall!.id!,
                    seatNumber: int.tryParse(seatData['seatNumber']) ?? 0,
                    rowNumber: int.tryParse(seatData['rowNumber']) ?? 0,
                  );

                  final seatProvider = Provider.of<SeatProvider>(context, listen: false);
                  seatProvider.update(seat.id!, updatedSeat).then((_) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.seatUpdatedSuccessfully),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _loadSeats();
                    }
                  }).catchError((e) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.failedToUpdateSeat),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  });
                }
              },
              child: Text(l10n.update),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(l10n.confirmDeleteSeat),
                      content: Text(l10n.areYouSureDeleteSeat),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(l10n.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final seatProvider = Provider.of<SeatProvider>(context, listen: false);
                            seatProvider.delete(seat.id!).then((_) {
                              if (mounted) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.seatDeletedSuccessfully),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                _loadSeats();
                              }
                            }).catchError((e) {
                              if (mounted) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.failedToDeleteSeat),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSeatDialog(AppLocalizations l10n) {
    final formKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.addNewSeat),
          content: FormBuilder(
            key: formKey,
            initialValue: {
              'seatNumber': '',
              'rowNumber': '',
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'seatNumber',
                  decoration: InputDecoration(labelText: 'Seat Number'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please enter seat number'),
                  ]),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'rowNumber',
                  decoration: InputDecoration(labelText: 'Row Number'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Please enter row number'),
                  ]),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.saveAndValidate() ?? false) {
                  final seatData = formKey.currentState!.value;
                  
                  final currentSeatCount = _seats.length;
                  final hallCapacity = widget.hall?.capacity ?? 0;
                  
                  if (currentSeatCount >= hallCapacity) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.cannotAddMoreSeats(hallCapacity, currentSeatCount)),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  
                  final seat = Seat(
                    id: null,
                    hallId: widget.hall!.id!,
                    seatNumber: int.tryParse(seatData['seatNumber']) ?? 0,
                    rowNumber: int.tryParse(seatData['rowNumber']) ?? 0,
                  );

                  final seatProvider = Provider.of<SeatProvider>(context, listen: false);
                  seatProvider.insert(seat).then((_) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.seatSavedSuccessfully),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _loadSeats();
                    }
                  }).catchError((e) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.failedToSaveSeat),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  });
                }
              },
              child: Text(l10n.create),
            ),
          ],
        );
      },
    );
  }
} 