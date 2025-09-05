import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/promotion.dart';
import 'base_provider.dart';
import '../config/api_config.dart';

class PromotionProvider extends BaseProvider<Promotion> {
  PromotionProvider() : super('Promotion');

  @override
  Promotion fromJson(data) {
    return Promotion.fromJson(data);
  }

  Future<Promotion?> validateCode(String code) async {
    try {
      var url = Uri.parse('${ApiConfig.baseUrl}Promotion/validate/$code');
      print('validating code: $code');
      print('URL: $url');
      
      var response = await http.get(url, headers: createHeaders());
      print('response status: ${response.statusCode}');
      print('response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else if (response.statusCode == 404) {
        return null;
      } else if (response.statusCode == 400) {
        var error = jsonDecode(response.body);
        throw Exception(error.toString());
      }
      throw Exception('failed to validate promotion code');
    } catch (e) {
      print('error in validateCode: $e');
      if (e.toString().contains('You have already used this promotion code')) {
        throw Exception('You have already used this promotion code');
      }
      rethrow;
    }
  }
}