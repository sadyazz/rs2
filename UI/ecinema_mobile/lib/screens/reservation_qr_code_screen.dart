import 'package:flutter/material.dart';
import '../models/reservation.dart';
import '../layouts/master_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'user_reservations_screen.dart';

class ReservationQrCodeScreen extends StatefulWidget {
  final Reservation reservation;

  const ReservationQrCodeScreen({
    super.key,
    required this.reservation,
  });

  @override
  State<ReservationQrCodeScreen> createState() => _ReservationQrCodeScreenState();
}

class _ReservationQrCodeScreenState extends State<ReservationQrCodeScreen> {
  String? _qrCodeBase64;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateQRCode();
  }

  Future<void> _generateQRCode() async {
    try {
      print('🔍 Reservation ID: ${widget.reservation.id}');
      print('🔍 QR Code Base64: ${widget.reservation.qrcodeBase64?.substring(0, 50)}...');
      print('🔍 QR Code Length: ${widget.reservation.qrcodeBase64?.length ?? 0}');
      
      setState(() {
        _isLoading = false;
        _qrCodeBase64 = widget.reservation.qrcodeBase64;
      });

      if (_qrCodeBase64 == null) {
        print('⚠️ QR Code is null');
      } else {
        print('✅ QR Code loaded successfully');
      }
    } catch (e) {
      print('❌ Error in _generateQRCode: $e');
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return MasterScreen(
      // l10n.reservationSuccessful,
      '',
      SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildSuccessIcon(colorScheme),
            const SizedBox(height: 24),
            _buildSuccessMessage(l10n, colorScheme),
            const SizedBox(height: 32),
            _buildQrCode(_qrCodeBase64, colorScheme),
            const SizedBox(height: 32),
            _buildReservationDetails(l10n, colorScheme),
            const SizedBox(height: 48),
            _buildActionButtons(l10n, colorScheme, context),
          ],
        ),
      ),
      showAppBar: false,
      showBackButton: true,
      showBottomNav: false,
    );
  }

  Widget _buildSuccessIcon(ColorScheme colorScheme) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        size: 48,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSuccessMessage(AppLocalizations l10n, ColorScheme colorScheme) {
    return Builder(
      builder: (context) => Column(
        children: [
          Text(
            l10n.reservationSuccessful,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4F8593),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.reservationSuccessfulMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQrCode(String? qrData, ColorScheme colorScheme) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading QR code',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (qrData == null) {
      return Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text('No QR code available'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Builder(
        builder: (context) {
          try {
            final decodedData = base64Decode(qrData);
            print('✅ Successfully decoded QR code data');
            return Image.memory(
              decodedData,
              width: 200.0,
              height: 200.0,
              fit: BoxFit.contain,
            );
          } catch (e) {
            print('❌ Error decoding QR code: $e');
            print('❌ QR code data: ${qrData.substring(0, 50)}...');
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                                  Text(
                    'Error decoding QR code',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildReservationDetails(AppLocalizations l10n, ColorScheme colorScheme) {
    return Builder(
      builder: (context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.reservationDetails,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4F8593),
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(l10n.movieUppercase, widget.reservation.movieTitle),
              _buildDetailRow(l10n.date, _formatDate(widget.reservation.screeningStartTime)),
              _buildDetailRow(l10n.time, _formatTime(widget.reservation.screeningStartTime)),
              _buildDetailRow(l10n.hall, widget.reservation.hallName),
              _buildDetailRow(l10n.seatsUppercase, _formatSeats()),
              _buildDetailRow(l10n.totalPrice, '${widget.reservation.totalPrice.toStringAsFixed(2)} €'),
              _buildDetailRow(l10n.paymentMethod, _getPaymentMethodText(l10n)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n, ColorScheme colorScheme, BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _goToHome(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F8593),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              l10n.goToHome,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // SizedBox(
        //   width: double.infinity,
        //   height: 56,
        //   child: OutlinedButton(
        //     onPressed: () => _viewMyReservations(context),
        //     style: OutlinedButton.styleFrom(
        //       foregroundColor: colorScheme.primary,
        //       side: BorderSide(color: colorScheme.primary),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //     child: Text(
        //       l10n.viewMyReservations,
        //       style: Theme.of(context).textTheme.titleMedium?.copyWith(
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }



  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatSeats() {
    // Koristi seat names umjesto IDs ako su dostupni
    if (widget.reservation.seatNames != null && widget.reservation.seatNames!.isNotEmpty) {
      return widget.reservation.seatNames!.join(', ');
    }
    // Fallback na IDs ako nema imena
    return widget.reservation.seatIds.map((id) => 'Seat $id').join(', ');
  }

  String _getPaymentMethodText(AppLocalizations l10n) {
    return widget.reservation.paymentStatus == 'Stripe' ? l10n.stripe : l10n.cash;
  }

  void _goToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );
  }

  void _viewMyReservations(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const UserReservationsScreen(),
      ),
    );
  }
}
