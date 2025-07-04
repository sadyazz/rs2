import 'package:ecinema_desktop/models/actor.dart';
import 'package:ecinema_desktop/providers/base_provider.dart';

class ActorProvider extends BaseProvider {
  ActorProvider() : super('Actor');
  
  @override
  Actor fromJson(data) {
    return Actor.fromJson(data);
  }
}