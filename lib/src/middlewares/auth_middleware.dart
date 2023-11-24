
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_movie_api/src/extensions/http_ext.dart';
import 'package:dart_movie_api/src/models/token_secret.dart';
import 'package:dart_movie_api/src/service/provider.dart';
import 'package:dart_movie_api/src/service/token_service.dart';
import 'package:shelf/shelf.dart';

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) {
      try {
        final ts = Provider.of.fetch<TokenService>();
        final tsInst = Provider.of.fetch<TokenSecret>();
        final authHeader = request.headers['Authorization'];
        String? token;
        JWT? jwt;
        if (authHeader != null && authHeader.startsWith('Bearer ')) {
          token = authHeader.substring(7);
          jwt = ts.verifyJwt(token, tsInst.getSecretKey);
        }
        final updatedRequest = request.change(context: {'authDetails': jwt});
        return innerHandler(updatedRequest);
      }on JwtCustomException  catch(err){
        return Response.badRequest(
            body: json.encode({'error': err.error}),
            headers: CustomHeader.json.getType); 
      }
    };
  };
}
