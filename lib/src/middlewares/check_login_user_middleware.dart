import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_movie_api/src/extensions/http_ext.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';

Middleware checkLoginUser(DbCollection store) {
  return (Handler innerHandler) {
    return (Request request) async {
      final query = request.requestedUri.path.substring(6).toLowerCase();
      if (query == "me") {
        if (request.context['authDetails'] == null) {
          return Response.forbidden(
              json.encode({'error': 'Not authorized to perform this action'}),
              headers: CustomHeader.json.getType);
        }
        final userId = (request.context['authDetails'] as JWT).subject;
        if (userId != null) {
          final currUser = await store
              .findOne(where.eq('_id', ObjectId.fromHexString(userId)));
          final updatedRequest = request.change(context: {'user': currUser});
          return innerHandler(updatedRequest);
        }
      }

      return innerHandler(request);
    };
  };
}
