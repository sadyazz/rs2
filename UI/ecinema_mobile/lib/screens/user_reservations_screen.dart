import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../layouts/master_screen.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/info_row.dart';

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
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _futureReservations = [];
      _pastReservations = [];
    });

    try {
      final reservationProvider = context.read<ReservationProvider>();
      
      final userId = AuthProvider.userId;

      if (userId != null) {
        final futureReservations = await reservationProvider.getUserReservations(userId, true);
        final pastReservations = await reservationProvider.getUserReservations(userId, false);
        
        if (!mounted) return;
        
        setState(() {
          _futureReservations = List.from(futureReservations);
          _pastReservations = List.from(pastReservations);
          _isLoading = false;
        });
        
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
      Column(
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
    
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
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
                          InfoRow(label: l10n.date, value: _formatDateTime(reservation.screeningStartTime)),
                          InfoRow(label: l10n.time, value: _formatTime(reservation.screeningStartTime)),
                          InfoRow(label: l10n.hall, value: reservation.hallName ?? 'N/A'),
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
                      color: _getStatusColor(reservation.reservationState),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(reservation.reservationState, l10n),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InfoRow(label: l10n.seatsUppercase, value: _formatSeatsWithNames(reservation)),
            InfoRow(label: l10n.total, value: '${reservation.totalPrice.toStringAsFixed(2)} ${l10n.currency}'),
            if (reservation.promotionName != null)
              InfoRow(label: l10n.promotion, value: reservation.promotionName!),
            if (reservation.paymentStatus != null)
              InfoRow(label: l10n.payment, value: reservation.paymentStatus!),
            const SizedBox(height: 16),
            if (reservation.reservationState != 'CancelledReservationState' && 
                reservation.reservationState != 'UsedReservationState')
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



  Color _getStatusColor(String state) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (state) {
      case 'ApprovedReservationState':
        return Colors.green;
      case 'UsedReservationState':
        return const Color(0xFF4F8593);
      case 'RejectedReservationState':
        return colorScheme.error;
      case 'ExpiredReservationState':
        return Colors.orange;
      case 'PendingReservationState':
        return Colors.blue;
      case 'InitialReservationState':
        return Colors.grey;
      case 'CancelledReservationState':
        return Colors.red;
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

  String _formatSeatsWithNames(Reservation reservation) {
    if (reservation.seatIds.isEmpty) return 'N/A';
    
    if (reservation.seatNames != null && reservation.seatNames!.isNotEmpty) {
      return reservation.seatNames!.join(', ');
    }
    
    return reservation.seatIds.map((id) => 'Seat $id').join(', ');
  }

  String _getStatusText(String state, AppLocalizations l10n) {
    switch (state) {
      case 'ApprovedReservationState':
        return l10n.reservationApproved;
      case 'UsedReservationState':
        return l10n.reservationUsed;
      case 'RejectedReservationState':
        return l10n.reservationRejected;
      case 'ExpiredReservationState':
        return l10n.reservationExpired;
      case 'PendingReservationState':
        return l10n.reservationPending;
      case 'InitialReservationState':
        return l10n.reservationInitial;
      case 'CancelledReservationState':
        return l10n.reservationCancelled;
      default:
        return state;
    }
  }

  void _showReservationDetails(Reservation reservation, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  reservation.movieTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (reservation.qrcodeBase64 != null && reservation.qrcodeBase64!.isNotEmpty)
                  Container(
                    width: 210,
                    height: 210,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Image.memory(
                        base64Decode(reservation.qrcodeBase64!),
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                if (reservation.qrcodeBase64 != null && reservation.qrcodeBase64!.isNotEmpty)
                  const SizedBox(height: 20),
                InfoRow(label: l10n.date, value: _formatDateTime(reservation.screeningStartTime), icon: Icons.calendar_today),
                InfoRow(label: l10n.time, value: _formatTime(reservation.screeningStartTime), icon: Icons.access_time),
                InfoRow(label: l10n.hall, value: reservation.hallName ?? 'N/A', icon: Icons.room),
                InfoRow(label: l10n.seatsUppercase, value: _formatSeatsWithNames(reservation), icon: Icons.chair),
                InfoRow(label: l10n.totalPrice, value: '${reservation.totalPrice.toStringAsFixed(2)} ${l10n.currency}', icon: Icons.attach_money),
                InfoRow(label: l10n.status, value: _getStatusText(reservation.reservationState, l10n), icon: Icons.info_outline),
                if (reservation.promotionName != null)
                  InfoRow(label: 'Promotion', value: reservation.promotionName!, icon: Icons.local_offer),
                if (reservation.paymentStatus != null)
                  InfoRow(label: l10n.paymentStatus, value: reservation.paymentStatus!, icon: Icons.payment),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _cancelReservation(Reservation reservation, AppLocalizations l10n) {
    final cancellationDeadline = reservation.screeningStartTime.subtract(const Duration(days: 1));
    final deadlineFormatted = "${cancellationDeadline.day}.${cancellationDeadline.month}.${cancellationDeadline.year}";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.cancelReservation),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.cancelReservationConfirmation(reservation.movieTitle)),
              const SizedBox(height: 16),
              Text(
                l10n.cancellationDeadlineInfo(deadlineFormatted),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.no),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await UserProvider.cancelReservation(reservation.id);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.reservationCancelledSuccessfully),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  _loadReservations();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceFirst("Exception: ", "")),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
