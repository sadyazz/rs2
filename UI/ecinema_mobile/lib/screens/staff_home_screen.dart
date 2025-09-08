import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../utils/error_dialog.dart';
import '../screens/change_password_screen.dart';
import '../models/reservation_response.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    final user = UserProvider.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: Text('Staff Portal - ${user?.firstName} ${user?.lastName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.password),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthProvider.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isScanning
                ? MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        _handleBarcode(barcode.rawValue);
                      }
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isScanning = true;
                    });
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan Ticket'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.toggleTorch();
                  },
                  icon: const Icon(Icons.flashlight_on),
                  label: const Text('Toggle Flash'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleBarcode(String? rawValue) async {
    if (rawValue == null) return;

    setState(() {
      isScanning = false;
    });

    try {
      final idMatch = RegExp(r'Reservation ID: (\d+)').firstMatch(rawValue);
      final reservationId = idMatch?.group(1) != null ? int.tryParse(idMatch!.group(1)!) : null;
      
      if (reservationId == null) {
        if (mounted) {
          _showErrorBottomSheet(context, 'Invalid QR code format - could not find reservation ID');
        }
        return;
      }

      try {
        final response = await UserProvider.verifyReservation(reservationId);
        if (mounted) {
          _showSuccessBottomSheet(context, response);
        }
      } catch (e) {
        if (mounted) {
          final errorMessage = e.toString().replaceFirst("Exception: ", "");
          _showErrorBottomSheet(context, errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString().replaceFirst("Exception: ", "");
        showErrorDialog(context, errorMessage);
        setState(() {
          isScanning = true;
        });
      }
    }
  }

  void _showSuccessBottomSheet(BuildContext context, ReservationResponse response) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          setState(() {
            isScanning = true;
          });
          return true;
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          'Valid Ticket',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow('Movie', response.movieTitle),
                          _buildInfoRow('Date', DateFormat('dd/MM/yyyy').format(response.screeningStartTime)),
                          _buildInfoRow('Time', DateFormat('HH:mm').format(response.screeningStartTime)),
                          _buildInfoRow('Hall', response.hallName),
                          _buildInfoRow('Seats', response.seatNames.join(', ')),
                          _buildInfoRow('Total Price', '${response.totalPrice.toStringAsFixed(2)} \$'),
                          _buildInfoRow('Payment Method', response.paymentType ?? 'Cash'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  top: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isScanning = true;
                      });
                    },
                    child: const Text(
                      'Confirm Entry',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorBottomSheet(BuildContext context, String message) {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          setState(() {
            isScanning = true;
          });
          return true;
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          'Invalid Ticket',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  top: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        isScanning = true;
                      });
                    },
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
