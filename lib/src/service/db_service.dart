import 'package:mongo_dart/mongo_dart.dart';

class DbService {
  late Db _db;
  Db get db => _db;
  bool _isOpen = false;

  Future<void> openDb() async {
    try {
      _db = await Db.create("mongodb://127.0.0.1:27017/dart_backend");
      await _db.open();
      _isOpen = true;
      print("Db opened");
    } catch (e) {
      print("Error :$e");
    }
  }

  DbCollection getStore(String store) {
    if (!_isOpen) {
      throw DatabaseNotOpenException(error: "Db not opened");
    }
    return _db.collection(store);
  }

  @override
  String toString() {
    return "DbService Hashcode: $hashCode";
  }
}

class DatabaseNotOpenException implements Exception {
  final String error;

  DatabaseNotOpenException({required this.error});
}
