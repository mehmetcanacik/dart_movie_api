import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_movie_api/src/extensions/http_ext.dart';
import 'package:dart_movie_api/src/middlewares/check_authorization.dart';
import 'package:dart_movie_api/src/models/movie.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class MovieService {
  final DbCollection store;

  const MovieService({required this.store});

  Handler get router {
    final app = Router();

    app.get('/', (Request request) async {
      try {
        final allMovies = await store
            .find()
            .map<Movie>((m) => Movie.fromJson(m))
            .cast<Movie>()
            .toList();
        final moviesLength = allMovies.length;
        return Response.ok(
            json.encode({'length': moviesLength, 'movies': allMovies}),
            headers: CustomHeader.json.getType);
      }on JWTUndefinedException catch (e) {
        return Response.badRequest(
            body: json.encode({'error': 'Invalid JWT'}),
            headers: CustomHeader.json.getType);
      }
    });

    app.post('/add', (Request request) async {
      final payLoad =
          json.decode(await request.readAsString()) as Map<String, dynamic>;
      final movieId = Uuid().v4().substring(0, 8);
      final movie = Movie(
          movieId: movieId,
          rating: payLoad['rating'] as double,
          title: payLoad['title'] as String,
          year: payLoad['year'] as int);

      final currentMovie =
          await store.findOne(where.eq('title', payLoad['title'] as String));
      if (currentMovie != null) {
        return Response.badRequest(
            body: json.encode({'error': 'Movie already exists...'}),
            headers: CustomHeader.json.getType);
      }
      await store.insertOne(movie.toJson());
      return Response(HttpStatus.ok,
          body: json
              .encode({'message': 'A film added', 'movie_name': movie.title}),
          headers: CustomHeader.json.getType);
    });

    final handler =
        Pipeline().addMiddleware(checkAuthorization()).addHandler(app);
    return handler;
  }
}
