import 'package:ecinema_desktop/models/seat.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';

class SeatProvider extends BaseProvider<Seat> {
  SeatProvider() : super("Seat");

  @override
  Seat fromJson(data) {
    return Seat.fromJson(data);
  }

  Future<List<Seat>> getByHallId(int hallId) async {
    try {
      final result = await get(filter: {'hallId': hallId, 'pageSize': 1000});
      return result.items ?? [];
    } catch (e) {
      print('Error fetching seats by hall ID: $e');
      return [];
    }
  }
}