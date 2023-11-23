import 'dart:convert';
import 'dart:io';

import 'package:dart_movie_api/src/extensions/http_ext.dart';
import 'package:dart_movie_api/src/extensions/parse_ext.dart';
import 'package:dart_movie_api/src/service/password_service.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:dart_movie_api/src/service/token_service.dart';
import 'package:dart_movie_api/src/utils/email_validator.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthService {
  final DbCollection store;
  final String secret;

  const AuthService({
    required this.store,
    required this.secret,
  });

  Handler get router {
    final app = Router();
    final rx = Provider.of.fetch<RegexValidator>();
    final ps = Provider.of.fetch<PasswordService>();
    final ts = Provider.of.fetch<TokenService>();
    //! Register POST Request
    app.post("/register", (Request request) async {
      final user = await request.parseData;
      if (user.email!.isEmpty || user.password!.isEmpty) {
        return Response(HttpStatus.badRequest,
            body: json.encode({'error': 'Please provider your email/password'}),
            headers: CustomHeader.json.getType);
      }
      final addedUser = await store.findOne(where.eq('email', user.email));
      if (addedUser != null) {
        return Response.badRequest(
            body: json.encode({'error': 'User already exist...'}),
            headers: CustomHeader.json.getType);
      }
      if (!rx.isValid(user.email!)) {
        return Response(HttpStatus.badRequest,
            body:
                json.encode({'error': 'Please provide correct email address'}),
            headers: CustomHeader.json.getType);
      }
      final salt = ps.generateSalt();
      final hashedPassword = ps.hashPassword(user.password!, salt);
      await store.insertOne(
          {'email': user.email, 'password': hashedPassword, 'salt': salt});
      return Response.ok(
          json.encode({'message': 'User saved. Please redirect to Login.'}),
          headers: CustomHeader.json.getType);
    });

    app.post('/login', (Request request) async {
      final user = await request.parseData;
      if (user.email!.isEmpty || user.password!.isEmpty) {
        return Response.badRequest(
            body: json.encode({'error': 'Please provide your email/password'}),
            headers: CustomHeader.json.getType);
      }

      if (!rx.isValid(user.email!)) {
        return Response.badRequest(
            body:
                json.encode({'error': 'Please provide correct email address'}),
            headers: CustomHeader.json.getType);
      }
      final dbUser = await store.findOne(where.eq('email', user.email));
      if (dbUser == null) {
        return Response.forbidden(json.encode({'message': 'User not found!'}),
            headers: CustomHeader.json.getType);
      }
      final hashedPassword = ps.hashPassword(user.password!, dbUser['salt']);
      if (hashedPassword != dbUser['password']) {
        return Response.forbidden(
            json.encode({'message': 'Incorrect user mail/password'}),
            headers: CustomHeader.json.getType);
      }
      try {
        final userId = (dbUser['_id'] as ObjectId).toHexString();
        final tokenPair = await ts.createTokenPair(userId);
        return Response(
          HttpStatus.ok,
          body: json.encode(tokenPair.toJson()),
          headers: CustomHeader.json.getType,
        );
      } catch (e) {
        print('Error: $e');
        return Response.internalServerError(
            body: json.encode({
          'message': 'There was a problem logging you in. Please try again...'
        }),headers: CustomHeader.json.getType);
      }
    });

    return app;
  }
}
