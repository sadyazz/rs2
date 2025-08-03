import '../models/screening.dart';
import 'base_provider.dart';

class ScreeningProvider extends BaseProvider<Screening> {
  ScreeningProvider() : super("Screening");

  @override
  Screening fromJson(data) {
    return Screening.fromJson(data);
  }
} 