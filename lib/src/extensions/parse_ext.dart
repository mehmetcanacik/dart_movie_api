import 'dart:convert';

import 'package:dart_movie_api/src/models/req_user.dart';
import 'package:shelf/shelf.dart';

extension ParseEmailAndPasswordX on Request {
  Future<ReqUser> get parseData async =>
      ReqUser.fromJson(json.decode(await readAsString()) as UserType);
}