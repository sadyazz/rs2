import 'package:ecinema_desktop/models/screening.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';
import 'package:ecinema_desktop/models/seat.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ScreeningProvider extends BaseProvider<Screening> {
  ScreeningProvider() : super('Screening');

  @override
  Screening fromJson(data) {
    return Screening.fromJson(data);
  }

  Future<List<Seat>> getSeatsForScreening(int screeningId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5190/Screening/$screeningId/seats'),
        headers: createHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final seats = data.map((json) => Seat.fromJson(json)).toList();
        return seats;
      }
      return [];
    } catch (e) {
      print('Error fetching seats for screening: $e');
      return [];
    }
  }

  Future<int> generateSeatsForScreening(int screeningId) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5190/Screening/$screeningId/generate-seats'),
        headers: createHeaders(),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['totalSeats'] ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error generating seats for screening: $e');
      throw Exception('Failed to generate seats for screening: $e');
    }
  }
} 