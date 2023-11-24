import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_movie_api/src/constants/app_constants.dart';
import 'package:dart_movie_api/src/middlewares/auth_middleware.dart';
import 'package:dart_movie_api/src/middlewares/cors_middleware.dart';

import 'package:dart_movie_api/src/service/auth_service.dart';
import 'package:dart_movie_api/src/service/db_service.dart';
import 'package:dart_movie_api/src/service/movie_service.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:dart_movie_api/src/utils/config.dart';
import 'package:dart_movie_api/src/utils/init.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> arguments) async {
  await initData();
  final app = Router();
  final port =Platform.environment['PORT']??Env.port;
  final dbInst = Provider.of.fetch<DbService>();
  await dbInst.openDb();

  app.get('/', (Request request) {
    return Response.ok(json.encode({'message': 'Hello from backend..'}),
        headers: {'Content-type': 'application/json'});
  });

  app.mount(
      '/auth',
      AuthService(
              store: dbInst.getStore(AppConstants.userCollection),
              secret: "12345")
          .router);

  app.mount(
      '/movies',
      MovieService(store: dbInst.getStore(AppConstants.movieCollection))
          .router);

  final handler = Pipeline()
      .addMiddleware(corsMiddleware())
      .addMiddleware(authMiddleware())
      .addHandler(app);

  await serve(handler, InternetAddress.anyIPv4, int.parse(port));
  print("Server is running on Port 8080");
}

