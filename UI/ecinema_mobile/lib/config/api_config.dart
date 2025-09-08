import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get stripePublishableKey => dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static String get baseUrl {
    if (Platform.isAndroid) {
      return "http://10.0.2.2:5190/"; // android emulator
    } else if (Platform.isIOS) {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return "http://localhost:5190/"; // iOS simulator
      } else {
        return "http://192.168.0.47:5190/"; // physical iOS device
      }
    }
    return "http://localhost:5190/"; // default
  }
}
