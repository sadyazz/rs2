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
          'isActive': widget.hall?.isActive ?? true,
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
              ),
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: l10n.pleaseEnterHallCapacity),
                FormBuilderValidators.min(1, errorText: l10n.capacityMustBeAtLeastOne),
              ]),
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
            
            FormBuilderSwitch(
              name: 'isActive',
              title: Text(l10n.isActive),
            ),
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
          isActive: formData['isActive'],
        );

        if (widget.hall == null) {
          await hallProvider.insert(hall);
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
                    'Seats Management',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddSeatDialog(l10n);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Seat'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoadingSeats)
                const Center(child: CircularProgressIndicator())
              else if (_seats.isEmpty)
                Center(
                  child: Text(
                    'No seats found for this hall',
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
            color: seat.isActive ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: seat.isActive ? Colors.green.shade700 : Colors.grey.shade600,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              '${seat.seatNumber}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: seat.isActive ? Colors.white : Colors.grey.shade300,
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
          title: Text('Edit Seat'),
          content: FormBuilder(
            key: formKey,
            initialValue: {
              'seatNumber': seat.seatNumber.toString(),
              'rowNumber': seat.rowNumber.toString(),
              'isActive': seat.isActive,
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
                FormBuilderSwitch(
                  name: 'isActive',
                  title: Text(l10n.isActive),
                ),
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
                    isActive: seatData['isActive'],
                  );

                  final seatProvider = Provider.of<SeatProvider>(context, listen: false);
                  seatProvider.update(seat.id!, updatedSeat).then((_) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Seat updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _loadSeats(); // Reload seats to update the grid
                    }
                  }).catchError((e) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update seat'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  });
                }
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Delete Seat'),
                      content: Text('Are you sure you want to delete this seat?'),
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
                                Navigator.of(context).pop(); // Close confirmation dialog
                                Navigator.of(context).pop(); // Close edit dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Seat deleted successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                _loadSeats(); // Reload seats to update the grid
                              }
                            }).catchError((e) {
                              if (mounted) {
                                Navigator.of(context).pop(); // Close confirmation dialog
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to delete seat'),
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
    final isEditing = widget.hall != null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Seat'),
          content: FormBuilder(
            key: formKey,
            initialValue: {
              'seatNumber': '',
              'rowNumber': '',
              'isActive': true,
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
                FormBuilderSwitch(
                  name: 'isActive',
                  title: Text(l10n.isActive),
                ),
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
                  final seat = Seat(
                    id: null,
                    hallId: widget.hall!.id!,
                    seatNumber: int.tryParse(seatData['seatNumber']) ?? 0,
                    rowNumber: int.tryParse(seatData['rowNumber']) ?? 0,
                    isActive: seatData['isActive'],
                  );

                  final seatProvider = Provider.of<SeatProvider>(context, listen: false);
                  seatProvider.insert(seat).then((_) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Seat saved successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _loadSeats(); // Reload seats to update the grid
                    }
                  }).catchError((e) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to save seat'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  });
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
} 