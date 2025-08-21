import '../models/screening.dart';
import '../models/seat.dart';
import 'base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ScreeningProvider extends BaseProvider<Screening> {
  ScreeningProvider() : super("Screening");

  @override
  Screening fromJson(data) {
    return Screening.fromJson(data);
  }

  Future<List<Seat>> getSeatsForScreening(int screeningId) async {
    try {
      final url = 'http://10.0.2.2:5190/Screening/$screeningId/seats';
      final uri = Uri.parse(url);
      final headers = createHeaders();

      print('🔍 Fetching seats for screening $screeningId from: $url');

      final response = await http.get(uri, headers: headers);

      if (isValidResponse(response)) {
        final data = jsonDecode(response.body) as List;
        final seats = data
            .map((item) {
              try {
                return Seat.fromJson(item);
              } catch (e) {
                print('❌ Error parsing seat: $e');
                return null;
              }
            })
            .whereType<Seat>()
            .toList();

        print('✅ Loaded ${seats.length} seats for screening $screeningId');
        return seats;
      } else {
        throw Exception('Failed to get seats for screening: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting seats for screening: $e');
      throw Exception('Failed to get seats for screening: $e');
    }
  }

  Future<void> generateSeatsForHall(int hallId) async {
    try {
      final url = 'http://10.0.2.2:5190/Hall/$hallId/generate-seats';
      final uri = Uri.parse(url);
      final headers = createHeaders();

      print('🔍 Generating seats for hall $hallId from: $url');

      final response = await http.post(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw Exception('Failed to generate seats for hall: ${response.statusCode}');
      }

      print('✅ Seats generated successfully for hall $hallId');
    } catch (e) {
      print('❌ Error generating seats for hall: $e');
      throw Exception('Failed to generate seats for hall: $e');
    }
  }
} 