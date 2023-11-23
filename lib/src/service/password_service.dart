import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

class PasswordService {
  String generateSalt([int length = 32]) {
    final rd = Random.secure();
    final saltBytes = List.generate(length, (_) => rd.nextInt(256));
    return base64.encode(saltBytes);
  }

  String hashPassword(String password, String salt) {
    final utfCodec = Utf8Codec();
    final key = utfCodec.encode(password);
    final saltBytes = utfCodec.encode(salt);
    return Hmac(sha256, key).convert(saltBytes).toString();
  }
}
