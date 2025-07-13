import 'package:ecinema_desktop/models/promotion.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';

class PromotionProvider extends BaseProvider<Promotion> {
  PromotionProvider() : super('Promotion');

  @override
  Promotion fromJson(dynamic json) {
    return Promotion.fromJson(json);
  }
} 