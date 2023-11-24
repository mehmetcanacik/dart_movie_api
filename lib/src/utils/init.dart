import 'package:dart_movie_api/src/constants/app_constants.dart';
import 'package:dart_movie_api/src/models/token_secret.dart';
import 'package:dart_movie_api/src/service/db_service.dart';
import 'package:dart_movie_api/src/service/password_service.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:dart_movie_api/src/service/token_service.dart';
import 'package:dart_movie_api/src/utils/email_validator.dart';

Future<void> initData() async {
  Provider.of
    ..register(
      DbService,
      () => DbService(),
    )
    ..register(RegexValidator,
        () => RegexValidator(regExpSource: AppConstants.emailRegex))
    ..register(PasswordService, () => PasswordService())
    ..register(
      TokenService,
      () => TokenService(
        store: Provider.of
            .fetch<DbService>()
            .getStore(AppConstants.tokenCollection),
      ),
    )
    ..register(TokenSecret, () => TokenSecret());
}
