import 'dart:io';

enum CustomHeader { json, html }

extension HttpHeadersX on CustomHeader {
  Map<String, Object>? get getType {
    switch (this) {
      case CustomHeader.json:
        return {HttpHeaders.contentTypeHeader: ContentType.json.mimeType};
      case CustomHeader.html:
        return {HttpHeaders.contentTypeHeader: 'text/html'};
    }
  }
}