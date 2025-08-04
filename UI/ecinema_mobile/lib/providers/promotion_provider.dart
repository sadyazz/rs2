import '../models/promotion.dart';
import 'base_provider.dart';

class PromotionProvider extends BaseProvider<Promotion> {
  PromotionProvider() : super('Promotion');

  @override
  Promotion fromJson(data) {
    return Promotion.fromJson(data);
  }
} 