import 'package:envied/envied.dart';

part 'config.g.dart';

@Envied()
abstract class Env {
  @EnviedField(varName: 'MONGO_URL')
  static const String mongoPath = _Env.mongoPath;
  @EnviedField(varName: 'SECRET_KEY')
  static const String secret = _Env.secret;

  @EnviedField(varName: 'PORT')
  static const String port = _Env.port;
}
