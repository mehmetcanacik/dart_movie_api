import 'package:shelf/shelf.dart';

Middleware corsMiddleware() {
  return createMiddleware(
    requestHandler: (Request request) {
      if (request.method == "OPTIONS") {
        return Response.ok('', headers: corsHeaders);
      }
      return null;
    },
    responseHandler: (Response response) {
      return response.change(headers: corsHeaders);
    },
  );
}

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE',
  'Access-Control-Allow-Headers': 'Origin, Content-type'
};
