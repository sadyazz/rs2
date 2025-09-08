import 'package:ecinema_desktop/models/hall.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';

class HallProvider extends BaseProvider<Hall> {
  HallProvider() : super("Hall");

  @override
  Hall fromJson(data) {
    return Hall.fromJson(data);
  }
} 
