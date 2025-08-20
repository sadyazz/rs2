import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../providers/auth_provider.dart';
import '../layouts/master_screen.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserReservationsScreen extends StatefulWidget {
  const UserReservationsScreen({super.key});

  @override
  State<UserReservationsScreen> createState() => _UserReservationsScreenState();
}

class _UserReservationsScreenState extends State<UserReservationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  List<Reservation> _futureReservations = [];
  List<Reservation> _pastReservations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReservations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final reservationProvider = context.read<ReservationProvider>();
      
      final userId = AuthProvider.userId;

      if (userId != null) {
        final futureReservations = await reservationProvider.getUserReservations(userId, true);
        
        final pastReservations = await reservationProvider.getUserReservations(userId, false);
        
        setState(() {
          _futureReservations = futureReservations;
          _pastReservations = pastReservations;
        });
        
      } else {
        print('❌ User ID is null!');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading reservations: $e'),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return MasterScreen(
      l10n.myReservations,
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: colorScheme.surface,
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: l10n.upcoming),
                      Tab(text: l10n.past),
                    ],
                    labelColor: colorScheme.primary,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    indicatorColor: colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildReservationsList(_futureReservations, true, l10n),
                      _buildReservationsList(_pastReservations, false, l10n),
                    ],
                  ),
                ),
              ],
            ),
      showAppBar: true,
      showBackButton: true,
      showBottomNav: false,
    );
  }

  Widget _buildReservationsList(List<Reservation> reservations, bool isUpcoming, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.event_busy : Icons.history,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? l10n.noUpcomingReservations : l10n.noPastReservations,
              style: TextStyle(
                fontSize: 18,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReservations,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reservations.length,
        itemBuilder: (context, index) {
          final reservation = reservations[index];
          return _buildReservationCard(reservation, l10n);
        },
      ),
    );
  }

  Widget _buildReservationCard(Reservation reservation, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (reservation.movieImage != null)
                      Container(
                        width: 60,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: MemoryImage(base64Decode(reservation.movieImage!)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 60,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme.surfaceContainerHighest,
                        ),
                        child: Icon(
                          Icons.movie,
                          size: 30,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reservation.movieTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(l10n.date, _formatDateTime(reservation.screeningStartTime)),
                          _buildInfoRow(l10n.time, _formatTime(reservation.screeningStartTime)),
                          _buildInfoRow(l10n.hall, reservation.hallName),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(reservation.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(reservation.status, l10n),
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(l10n.seats, _formatSeats(reservation.seatIds, l10n)),
            _buildInfoRow(l10n.total, '${reservation.totalPrice.toStringAsFixed(2)} ${l10n.currency}'),
            if (reservation.promotionName != null)
              _buildInfoRow(l10n.promotion, reservation.promotionName!),
            if (reservation.paymentStatus != null)
              _buildInfoRow(l10n.payment, reservation.paymentStatus!),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showReservationDetails(reservation, l10n),
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: Text(l10n.details),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _cancelReservation(reservation, l10n),
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: Text(l10n.cancel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status.toLowerCase()) {
      case 'reserved':
        return colorScheme.primary;
      case 'paid':
        return Colors.green;
      case 'cancelled':
        return colorScheme.error;
      case 'expired':
        return Colors.orange;
      default:
        return colorScheme.surfaceContainerHighest;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final formatted = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return formatted;
  }

  String _formatTime(DateTime dateTime) {
    final formatted = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return formatted;
  }

  String _formatSeats(List<int> seatIds, AppLocalizations l10n) {
    if (seatIds.isEmpty) return l10n.notAvailable;
    return seatIds.map((id) => '${l10n.seat} $id').join(', ');
  }

  String _getStatusText(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'reserved':
        return 'Reserved';
      case 'paid':
        return 'Confirmed';
      case 'cancelled':
        return 'Cancelled';
      case 'expired':
        return 'Expired';
      case 'pending':
        return 'On Hold';
      default:
        return status;
    }
  }

  void _showReservationDetails(Reservation reservation, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(reservation.movieTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(l10n.date, _formatDateTime(reservation.screeningStartTime)),
              _buildInfoRow(l10n.time, _formatTime(reservation.screeningStartTime)),
              _buildInfoRow(l10n.hall, reservation.hallName),
              _buildInfoRow(l10n.seats, _formatSeats(reservation.seatIds, l10n)),
              _buildInfoRow(l10n.tickets, '${reservation.numberOfTickets}'),
              _buildInfoRow(l10n.totalPrice, '${reservation.totalPrice.toStringAsFixed(2)} ${l10n.currency}'),
              _buildInfoRow(l10n.status, _getStatusText(reservation.status, l10n)),
              if (reservation.promotionName != null)
                _buildInfoRow('Promotion', reservation.promotionName!),
              if (reservation.paymentStatus != null)
                _buildInfoRow(l10n.paymentStatus, reservation.paymentStatus!),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  void _cancelReservation(Reservation reservation, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.cancelReservation),
          content: Text(l10n.cancelReservationConfirmation(reservation.movieTitle)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.no),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement cancel reservation logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.reservationCancelledSuccessfully),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.yesCancel),
            ),
          ],
        );
      },
    );
  }
}
