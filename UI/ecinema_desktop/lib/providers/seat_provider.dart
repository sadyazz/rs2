import 'package:ecinema_desktop/models/seat.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class SeatProvider extends BaseProvider<Seat> {
  SeatProvider() : super('Seat');

  @override
  Seat fromJson(data) {
    return Seat.fromJson(data);
  }

  Future<List<Seat>> getAllSeats() async {
    try {
      final result = await get(filter: {
        'pageSize': 1000,
        'includeTotalCount': true,
      });
      return result.items ?? [];
    } catch (e) {
      print('Error fetching seats: $e');
      return [];
    }
  }

  Future<void> generateAll() async {
    try {
      final headers = createHeaders();
      
      final response = await http.post(
        Uri.parse('http://localhost:5190/Seat/generate-all'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate seats');
      }
    } catch (e) {
      print('Error generating seats: $e');
      throw e;
    }
  }
}
