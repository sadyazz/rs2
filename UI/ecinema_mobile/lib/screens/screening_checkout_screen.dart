import 'package:flutter/material.dart';
import '../models/screening.dart';
import '../models/seat.dart';
import '../screens/reservation_qr_code_screen.dart';
import '../providers/reservation_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScreeningCheckoutScreen extends StatefulWidget {
  final Screening screening;
  final List<Seat> selectedSeats;
  final double totalPrice;

  const ScreeningCheckoutScreen({
    super.key,
    required this.screening,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  State<ScreeningCheckoutScreen> createState() => _ScreeningCheckoutScreenState();
}

class _ScreeningCheckoutScreenState extends State<ScreeningCheckoutScreen> {
  String selectedPaymentMethod = 'cash';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.checkout),
        backgroundColor: const Color(0xFF4F8593),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildScreeningDetails(l10n, colorScheme),
            const SizedBox(height: 24),
            _buildSelectedSeats(l10n, colorScheme),
            const SizedBox(height: 24),
            _buildPriceDetails(l10n, colorScheme),
            const SizedBox(height: 24),
            _buildPaymentMethodSelection(l10n, colorScheme),
            const SizedBox(height: 32),
            _buildProceedButton(l10n, colorScheme),
            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }

  Widget _buildScreeningDetails(AppLocalizations l10n, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.screeningDetails,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4F8593),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(l10n.movieUppercase, widget.screening.movieTitle ?? ''),
            _buildInfoRow(l10n.date, _formatDate(widget.screening.startTime)),
            _buildInfoRow(l10n.time, _formatTime(widget.screening.startTime)),
            _buildInfoRow(l10n.hall, widget.screening.hallName ?? ''),
            _buildInfoRow(l10n.format, widget.screening.screeningFormatName ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedSeats(AppLocalizations l10n, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.selectedSeats,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4F8593),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selectedSeats.map((seat) {
                return Chip(
                  label: Text(seat.name ?? 'Seat ${seat.id}'),
                  backgroundColor: colorScheme.primaryContainer,
                  labelStyle: TextStyle(color: colorScheme.onPrimaryContainer),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetails(AppLocalizations l10n, ColorScheme colorScheme) {
    final pricePerSeat = widget.totalPrice / widget.selectedSeats.length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.priceDetails,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4F8593),
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(l10n.pricePerSeat, '${pricePerSeat.toStringAsFixed(2)} ${l10n.currency}'),
            _buildInfoRow(l10n.numberOfSeats, '${widget.selectedSeats.length}'),
            const Divider(),
            _buildInfoRow(
              l10n.totalPrice,
              '${widget.totalPrice.toStringAsFixed(2)} ${l10n.currency}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSelection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.paymentMethod,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4F8593),
              ),
            ),
            const SizedBox(height: 16),
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(Icons.money, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(l10n.cash),
                ],
              ),
              value: 'cash',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(l10n.stripe),
                ],
              ),
              value: 'stripe',
              groupValue: selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProceedButton(AppLocalizations l10n, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isProcessing ? null : _proceedToPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F8593),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isProcessing
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                selectedPaymentMethod == 'cash' 
                    ? l10n.payWithCash 
                    : l10n.payWithStripe,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? const Color(0xFF4F8593) : null,
            ),
          ),
        ],
      ),
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

  void _proceedToPayment() async {
    setState(() {
      isProcessing = true;
    });

    try {
      if (selectedPaymentMethod == 'cash') {
        _processCashPayment();
      } else {
        _processStripePayment();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<void> _processCashPayment() async {
    try {
      setState(() {
        isProcessing = true;
      });

      final reservationProvider = ReservationProvider();
      
      // Kreiranje rezervacije na backendu
      final reservation = await reservationProvider.createReservation(
        screeningId: widget.screening.id!,
        seatIds: widget.selectedSeats.map((seat) => seat.id).toList(),
        totalPrice: widget.totalPrice,
        paymentType: 'Cash',
      );

      // Navigacija na QR kod ekran sa kreiranom rezervacijom
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReservationQrCodeScreen(
              reservation: reservation,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating reservation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
  }

  void _processStripePayment() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Stripe integration coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
