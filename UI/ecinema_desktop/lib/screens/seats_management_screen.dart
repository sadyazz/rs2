import 'package:ecinema_desktop/layouts/master_screen.dart';
import 'package:ecinema_desktop/models/seat.dart';
import 'package:ecinema_desktop/providers/seat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ecinema_desktop/l10n/app_localizations.dart';

class SeatsManagementScreen extends StatefulWidget {
  const SeatsManagementScreen({super.key});

  @override
  State<SeatsManagementScreen> createState() => _SeatsManagementScreenState();
}

class _SeatsManagementScreenState extends State<SeatsManagementScreen> {
  List<Seat> _seats = [];
  bool _isLoading = true;
  late SeatProvider _seatProvider;

  @override
  void initState() {
    super.initState();
    _seatProvider = context.read<SeatProvider>();
    _loadSeats();
  }

  Future<void> _loadSeats() async {
    try {
      setState(() => _isLoading = true);
      final seats = await _seatProvider.getAllSeats();
      setState(() {
        _seats = seats;
        _isLoading = false;
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
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return MasterScreen(
      l10n.seatsManagement,
      showDrawer: false,
      Center(
        child: _isLoading
          ? const CircularProgressIndicator()
          : Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_seat,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Seat Layout',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: _buildSeatsGrid(),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _generateAllSeats,
                            icon: const Icon(Icons.refresh),
                            label: Text(l10n.regenerateAll),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: () => _showAddSeatDialog(l10n),
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addSeat),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildSeatsGrid() {
    if (_seats.isEmpty) {
      return Center(
        child: Text(
          'No seats available',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey,
          ),
        ),
      );
    }

    final rows = ['A', 'B', 'C', 'D', 'E', 'F'];
    return Column(
      children: rows.map((row) {
        final rowSeats = _seats
          .where((s) => s.name?.startsWith(row) ?? false)
          .toList()
          ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  row,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...rowSeats.map((seat) => _buildSeatItem(seat)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeatItem(Seat seat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _showEditSeatDialog(seat),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                seat.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generateAllSeats() async {
    final l10n = AppLocalizations.of(context)!;
    
    try {
      await _seatProvider.generateAll();
      await _loadSeats();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.seatsGeneratedSuccessfully(_seats.length)),
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
  }

  void _showAddSeatDialog(AppLocalizations l10n) {
    if (_seats.length >= 48) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.maxSeatsReached),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addSeat),
        content: TextField(
          decoration: InputDecoration(
            labelText: l10n.seatName,
            hintText: l10n.seatNameFormat,
          ),
          onSubmitted: (value) async {
            if (_validateSeatName(value)) {
              try {
                await _seatProvider.insert(SeatUpsertRequest(name: value));
                if (mounted) {
                  Navigator.pop(context);
                  await _loadSeats();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.seatAddedSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.failedToAddSeat),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _showEditSeatDialog(Seat seat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editSeat),
        content: TextField(
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.seatName,
            hintText: AppLocalizations.of(context)!.seatNameFormat,
          ),
          controller: TextEditingController(text: seat.name),
          onSubmitted: (value) async {
            if (_validateSeatName(value, excludeSeatId: seat.id)) {
              try {
                await _seatProvider.update(seat.id!, SeatUpsertRequest(name: value));
                if (mounted) {
                  Navigator.pop(context);
                  await _loadSeats();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.seatUpdatedSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.failedToUpdateSeat),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _seatProvider.delete(seat.id!);
                if (mounted) {
                  Navigator.pop(context);
                  await _loadSeats();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.seatDeletedSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!.failedToDeleteSeat),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.delete),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.update),
          ),
        ],
      ),
    );
  }

  bool _validateSeatName(String name, {int? excludeSeatId}) {
    final l10n = AppLocalizations.of(context)!;
    final regex = RegExp(r'^[A-F][1-8]$');
    if (!regex.hasMatch(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.invalidSeatFormat),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    if (_seats.any((s) => s.name == name && s.id != excludeSeatId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.seatAlreadyExists(name)),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    return true;
  }
}
