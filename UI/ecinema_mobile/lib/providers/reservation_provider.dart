import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/base_provider.dart';
import '../providers/auth_provider.dart';
import '../models/reservation.dart';

class ReservationProvider extends BaseProvider<dynamic> {
  ReservationProvider() : super("reservation");

  @override
  dynamic fromJson(data) {
    return data;
  }

  Future<List<Map<String, dynamic>>> getAvailableSeats(int screeningId) async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:5190");
      
      final screeningUrl = "$baseUrl/api/screening/$screeningId";
      
      final screeningResponse = await http.get(
        Uri.parse(screeningUrl),
        headers: createHeaders(),
      );
      
      if (screeningResponse.statusCode == 404) {
        throw Exception('Screening not found. Backend API is not working properly. Please check backend configuration.');
      }
      
      if (!isValidResponse(screeningResponse)) {
        throw Exception('Failed to load screening: ${screeningResponse.statusCode} - ${screeningResponse.body}');
      }
      
      final screeningData = jsonDecode(screeningResponse.body);
      final hallId = screeningData['hallId'];
      
      if (hallId == null) {
        throw Exception('Screening has no hall assigned');
      }
      
      final seatsUrl = "$baseUrl/api/seat?hallId=$hallId";
      
      final seatsResponse = await http.get(
        Uri.parse(seatsUrl),
        headers: createHeaders(),
      );
      
      if (!isValidResponse(seatsResponse)) {
        throw Exception('Failed to load seats: ${seatsResponse.statusCode}');
      }
      
      final seatsData = jsonDecode(seatsResponse.body);
      final allSeats = seatsData['items'] as List;
      
      final reservationsUrl = "$baseUrl/api/reservation?screeningId=$screeningId";
      
      final reservationsResponse = await http.get(
        Uri.parse(reservationsUrl),
        headers: createHeaders(),
      );
      
      if (!isValidResponse(reservationsResponse)) {
        throw Exception('Failed to load reservations: ${reservationsResponse.statusCode}');
      }
      
      final reservationsData = jsonDecode(reservationsResponse.body);
      final reservations = reservationsData['items'] as List;
      
      final reservedSeatIds = reservations
          .where((r) => r['status'] != 'Cancelled' && r['status'] != 'Expired')
          .map((r) => r['seatId'])
          .toSet();
      
      final availableSeats = allSeats
          .where((seat) => !reservedSeatIds.contains(seat['id']))
          .map((seat) => {
            'id': seat['id'],
            'name': '${seat['row']}${seat['number']}',
            'row': seat['row'],
            'number': seat['number'],
          })
          .toList();
      
      return availableSeats.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to load available seats: $e');
    }
  }

  Future<Reservation> createReservation({
    required int screeningId,
    required List<int> seatIds,
    required double totalPrice,
    required String paymentType,
  }) async {
    try {
      final userId = AuthProvider.userId;
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:5190");

      final data = {
        'reservationTime': DateTime.now().toIso8601String(),
        'totalPrice': totalPrice.toString(),
        'originalPrice': totalPrice.toString(),
        'discountPercentage': 0,
        'status': 'Reserved',
        'userId': userId,
        'screeningId': screeningId,
        'paymentId': null,
        'promotionId': null,
        'numberOfTickets': seatIds.length,
        'paymentType': paymentType,
        'state': 'InitialReservationState',
        'isDeleted': false,
        'seatIds': seatIds,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/reservation'),
        headers: createHeaders(),
        body: jsonEncode(data),
      );

      if (!isValidResponse(response)) {
        throw Exception('Failed to create reservation: ${response.statusCode}');
      }

      final responseData = jsonDecode(response.body);
      return Reservation.fromJson(responseData);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Reservation>> getUserReservations(int userId, bool? isFuture) async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:5190");
      
      String url = '$baseUrl/reservation/user/$userId';
      if (isFuture != null) {
        url += '?isFuture=$isFuture';
      }

      final headers = createHeaders();
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (!isValidResponse(response)) {
        throw Exception('Failed to load user reservations: ${response.statusCode} - ${response.body}');
      }

      final List<dynamic> jsonList = jsonDecode(response.body);
      final reservations = jsonList
          .map((json) => Reservation.fromJson(json))
          .toList();

      return reservations;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getQRCode(int reservationId) async {
    try {
      final baseUrl = const String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:5190");
      final url = '$baseUrl/reservation/$reservationId/qrcode';
      
      final response = await http.get(
        Uri.parse(url),
        headers: createHeaders(),
      );

      if (!isValidResponse(response)) {
        throw Exception('Failed to load QR code');
      }

      return response.body;
    } catch (e) {
      rethrow;
    }
  }
}
