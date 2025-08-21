import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../models/screening.dart';
import '../models/seat_dto.dart';
import '../providers/screening_provider.dart';
import '../providers/utils.dart';
import '../screens/screening_checkout_screen.dart';

class ReservationScreen extends StatefulWidget {
  final Movie movie;
  final Screening screening;

  const ReservationScreen({
    super.key,
    required this.movie,
    required this.screening,
  });

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool isLoading = false;
  List<SeatDto> selectedSeats = [];
  List<SeatDto> availableSeats = [];
  List<SeatDto> reservedSeats = [];
  Screening? screeningDetails;
  int? totalColumns;
  int? totalRows;

  @override
  void initState() {
    super.initState();
    _loadScreeningDetails();
  }

  Future<void> _loadScreeningDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Koristimo postojeći ScreeningProvider koji već radi
      final screeningProvider = context.read<ScreeningProvider>();
      final screening = await screeningProvider.getById(widget.screening.id!);
      
      if (screening != null) {
        print('✅ Screening loaded successfully: ${screening.id}');
        print('✅ Hall ID: ${screening.hallId}');
        
        setState(() {
          screeningDetails = screening;
          isLoading = false;
        });
        
        // Učitavamo sedišta iz backenda
        await _loadSeatsForScreening(screening.id!);
      } else {
        print('❌ Screening not found');
        setState(() {
          availableSeats = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading screening: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.errorLoadingScreening}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadSeatsForScreening(int screeningId) async {
    try {
      final screeningProvider = context.read<ScreeningProvider>();
      final seats = await screeningProvider.getSeatsForScreening(screeningId);
      
      if (mounted) {
        setState(() {
          availableSeats = seats;
          isLoading = false;
          
          if (seats.isEmpty) {
            print('⚠️ No seats found for screening. Automatically generating seats.');
            _generateSeatsForHall();
          } else {
            print('✅ Loaded ${seats.length} seats for screening $screeningId');
            totalColumns = 15;
            totalRows = (seats.length / totalColumns!).ceil();
          }
        });
      }
    } catch (e) {
      print('❌ Error loading seats for screening: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.errorLoadingSeats}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _generateSeatsForHall() async {
    if (screeningDetails?.hallId == null) return;
    
    setState(() {
      isLoading = true;
    });
    
    try {
      final screeningProvider = context.read<ScreeningProvider>();
      await screeningProvider.generateSeatsForHall(screeningDetails!.hallId!);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.seatsGeneratedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );
      
      await _loadSeatsForScreening(widget.screening.id!);
    } catch (e) {
      print('❌ Error generating seats: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.errorGeneratingSeats}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  Future<void> _createReservation() async {
    print('🔍 _createReservation called');
    print('🔍 selectedSeats.length: ${selectedSeats.length}');
    print('🔍 selectedSeats: ${selectedSeats.map((s) => '${s.name} (${s.id})').join(', ')}');
    
    if (selectedSeats.isEmpty) {
      print('❌ No seats selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectAtLeastOneSeat),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final totalPrice = (widget.screening.basePrice ?? 0.0) * selectedSeats.length;
    print('🔍 Total price: $totalPrice');
    print('🔍 Navigating to ScreeningCheckoutScreen');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreeningCheckoutScreen(
          screening: widget.screening,
          selectedSeats: selectedSeats,
          totalPrice: totalPrice,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(l10n.reserveTicket),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          if (selectedSeats.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${selectedSeats.length} ${selectedSeats.length == 1 ? l10n.seat : l10n.seats}',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieInfo(l10n, colorScheme),
            const SizedBox(height: 24),
            _buildScreeningInfo(l10n, colorScheme),
            const SizedBox(height: 24),
            _buildSeatSelection(l10n, colorScheme),
            const SizedBox(height: 32),
            if (selectedSeats.isNotEmpty) ...[
              _buildPriceSummary(l10n, colorScheme),
              const SizedBox(height: 16),
            ],
            _buildReservationButton(l10n, colorScheme),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieInfo(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          if (widget.movie.image != null && widget.movie.image!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 120,
                child: imageFromString(widget.movie.image!),
              ),
            )
          else
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.movie,
                size: 40,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movie.title ?? l10n.unknownTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.movie.durationMinutes ?? 0} ${l10n.minutes}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreeningInfo(AppLocalizations l10n, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                            Text(
                    l10n.screeningDetails,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                _formatDate(widget.screening.startTime!),
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                _formatTime(widget.screening.startTime!),
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ],
          ),
          if (widget.screening.hallName != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.room, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  widget.screening.hallName!,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.attach_money, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                '${widget.screening.basePrice?.toStringAsFixed(2) ?? "0.00"} KM',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatSelection(AppLocalizations l10n, ColorScheme colorScheme) {
    print('🔍 Building seat selection - availableSeats: ${availableSeats.length}, totalColumns: $totalColumns, totalRows: $totalRows');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                  Text(
            l10n.selectSeat,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        _buildSeatLegend(colorScheme, l10n),
        const SizedBox(height: 12),
        if (isLoading)
          Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          )
        else if (availableSeats.isEmpty)
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.noAvailableSeats,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isLoading ? null : _generateSeatsForHall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                    ),
                    child: Text(
                      l10n.generateSeatsForHall,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: totalColumns ?? 10,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: availableSeats.length,
              itemBuilder: (context, index) {
                final seat = availableSeats[index];
                final isSelected = selectedSeats.any((s) => s.id == seat.id);
                final isReserved = seat.isReserved == true;
                
                return GestureDetector(
                  onTap: isReserved ? null : () {
                    print('🔍 Seat tapped: ${seat.name} (${seat.id})');
                    print('🔍 Current selectedSeats: ${selectedSeats.map((s) => '${s.name} (${s.id})').join(', ')}');
                    
                    setState(() {
                      if (isSelected) {
                        selectedSeats.removeWhere((s) => s.id == seat.id);
                        print('🔍 Removed seat: ${seat.name}');
                      } else {
                        selectedSeats.add(seat);
                        print('🔍 Added seat: ${seat.name}');
                      }
                    });
                    
                    print('🔍 After setState - selectedSeats: ${selectedSeats.map((s) => '${s.name} (${s.id})').join(', ')}');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isReserved 
                          ? Colors.red 
                          : isSelected 
                              ? colorScheme.primary 
                              : colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isReserved 
                            ? Colors.red 
                            : isSelected 
                                ? colorScheme.primary 
                                : colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Center(
                                              child: Text(
                          seat.name ?? 'Seat ${seat.id}',
                          style: TextStyle(
                            color: isSelected 
                                ? colorScheme.onPrimary 
                                : colorScheme.onSurface,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPriceSummary(AppLocalizations l10n, ColorScheme colorScheme) {
    final pricePerSeat = widget.screening.basePrice ?? 0.0;
    final totalPrice = pricePerSeat * selectedSeats.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.priceSummary,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.pricePerSeat,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${pricePerSeat.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.numberOfSeats,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                '${selectedSeats.length}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.total,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${totalPrice.toStringAsFixed(2)} €',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReservationButton(AppLocalizations l10n, ColorScheme colorScheme) {
    print('🔍 _buildReservationButton - isLoading: $isLoading, selectedSeats: ${selectedSeats.length}');
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : () {
          print('🔍 Button pressed!');
          _createReservation();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F8593),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                l10n.confirmReservation,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    return '$day.$month.$year';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildSeatLegend(ColorScheme colorScheme, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(
          color: Colors.transparent,
          borderColor: colorScheme.outline.withOpacity(0.3),
          label: l10n.available,
          colorScheme: colorScheme,
        ),
        _buildLegendItem(
          color: colorScheme.primary,
          borderColor: colorScheme.primary,
          label: l10n.selected,
          colorScheme: colorScheme,
        ),
        _buildLegendItem(
          color: Colors.red,
          borderColor: Colors.red,
          label: l10n.reserved,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required Color borderColor,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: borderColor),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
