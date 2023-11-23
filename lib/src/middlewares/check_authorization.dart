import 'dart:convert';

import 'package:dart_movie_api/src/extensions/http_ext.dart';
import 'package:shelf/shelf.dart';

Middleware checkAuthorization() {
  return (Handler innerHandler) {
    return (Request request) {
      if (request.context['authDetails'] == null) {
        return Response.forbidden(
            json.encode({'error': 'Not authorized to perform this action'}),
            headers: CustomHeader.json.getType);
      }

      return innerHandler(request);
    };
  };
}
