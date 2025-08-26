import 'package:ecinema_desktop/models/seat.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';

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
}