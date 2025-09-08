import 'package:ecinema_desktop/models/screening_format.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';

class ScreeningFormatProvider extends BaseProvider<ScreeningFormat> {
  ScreeningFormatProvider() : super("ScreeningFormat");

  @override
  ScreeningFormat fromJson(data) {
    return ScreeningFormat.fromJson(data);
  }
} 
