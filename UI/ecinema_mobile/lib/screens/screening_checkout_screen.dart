import 'package:flutter/material.dart';
import '../models/screening.dart';
import '../models/seat.dart';
import '../screens/reservation_qr_code_screen.dart';
import '../providers/reservation_provider.dart';
import '../providers/payment_provider.dart';
import '../providers/promotion_provider.dart';
import 'package:ecinema_mobile/l10n/app_localizations.dart';

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
  final TextEditingController _promoCodeController = TextEditingController();
  double? _discountAmount;
  int? _promotionId;
  bool _isCheckingPromoCode = false;
  bool _showPromoInput = false;

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
            _buildPromoCodeSection(l10n, colorScheme),
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
            Container(
              width: double.infinity,
              child: Wrap(
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
            if (_discountAmount != null) ...[
              _buildInfoRow(
                l10n.discount,
                '-${_discountAmount!.toStringAsFixed(2)} ${l10n.currency}',
                isDiscount: true,
              ),
              const Divider(),
            ],
            _buildInfoRow(
              l10n.totalPrice,
              '${(_discountAmount != null ? widget.totalPrice - _discountAmount! : widget.totalPrice).toStringAsFixed(2)} ${l10n.currency}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCodeSection(AppLocalizations l10n, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _showPromoInput = !_showPromoInput;
                if (!_showPromoInput) {
                  _promoCodeController.clear();
                  _discountAmount = null;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Text(
                    l10n.havePromoCode,
                    style: TextStyle(
                      color: const Color(0xFF4F8593),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _showPromoInput ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF4F8593),
                  ),
                ],
              ),
            ),
          ),
          if (_showPromoInput) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoCodeController,
                    decoration: InputDecoration(
                      hintText: l10n.enterPromoCode,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _isCheckingPromoCode
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          print('Button pressed');
                          if (_discountAmount == null) {
                            print('Calling _validatePromoCode');
                            _validatePromoCode();
                          } else {
                            print('Calling _removePromoCode');
                            _removePromoCode();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F8593),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                        child: Text(_discountAmount == null ? l10n.apply : l10n.remove),
                      ),
              ],
            ),
            if (_discountAmount != null) ...[
              const SizedBox(height: 8),
              Text(
                l10n.discountApplied('\$${_discountAmount!.toStringAsFixed(2)}'),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _validatePromoCode() async {
    final code = _promoCodeController.text.trim();
    final l10n = AppLocalizations.of(context)!;
    if (code.isEmpty) {
      print('Code is empty');
      return;
    }

    setState(() {
      _isCheckingPromoCode = true;
    });

    try {
      final promotionProvider = PromotionProvider();
      final promotion = await promotionProvider.validateCode(code);
      
      if (promotion != null) {
        final discountAmount = widget.totalPrice * (promotion.discountPercentage / 100);
        setState(() {
          _discountAmount = discountAmount;
          _promotionId = promotion.id;
        });
      } else {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.invalidPromoCode),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final message = e.toString()
            .replaceFirst('Exception: ', '')
            .replaceAll('"', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message.contains('You have already used this promotion code')
                ? l10n.promoCodeAlreadyUsed
                : message
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingPromoCode = false;
        });
      }
    }
  }

  void _removePromoCode() {
    setState(() {
      _discountAmount = null;
      _promotionId = null;
      _promoCodeController.clear();
    });
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
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
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

  Widget _buildInfoRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
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
              color: isTotal ? const Color(0xFF4F8593) : isDiscount ? Colors.green : null,
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
        await _processCashPayment();
      } else {
        await _processStripePayment();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
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

  Future<void> _processCashPayment() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final reservationProvider = ReservationProvider();
      
      final reservation = await reservationProvider.createReservation(
        screeningId: widget.screening.id!,
        seatIds: widget.selectedSeats.map((seat) => seat.id).toList(),
        totalPrice: _discountAmount != null ? widget.totalPrice - _discountAmount! : widget.totalPrice,
        promotionId: _promotionId,
        paymentType: 'Cash',
      );

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
            content: Text(
              e.toString().contains('You already have a reservation') 
                ? l10n.existingReservationError 
                : e.toString().replaceFirst('Exception: ', '')
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _processStripePayment() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final paymentProvider = PaymentProvider();
      final reservationProvider = ReservationProvider();

      final amountInCents = (widget.totalPrice * 100).round();

      final paymentIntentId = await paymentProvider.initializePayment(amountInCents);

      final reservation = await reservationProvider.processStripePayment(
        screeningId: widget.screening.id!,
        seatIds: widget.selectedSeats.map((seat) => seat.id).toList(),
        amount: widget.totalPrice,
        paymentIntentId: paymentIntentId,
      );

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
      print('Error in _processStripePayment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().toLowerCase().contains('you already have a reservation')
                ? l10n.existingReservationError
                : e.toString().toLowerCase().contains('payment flow has been cancelled') ||
                  e.toString().toLowerCase().contains('the payment flow has been cancelled')
                  ? l10n.paymentCancelled
                  : e.toString().contains('Failed to process payment:')
                    ? e.toString().split('Failed to process payment:')[1].trim()
                    : e.toString().replaceFirst('Exception: ', '')
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
