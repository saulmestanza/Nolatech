import 'package:nolatech/models/court_model.dart';
import 'package:nolatech/repository/db_init.dart';
import 'package:sqflite/sqflite.dart';

class CourtRepository extends DbInit {
  Database? _db;

  Future<List<CourtModel>> getAllCourts() async {
    _db = _db ?? await super.db;
    final result = await _db!.query('courts');
    if (result.isNotEmpty) {
      List<CourtModel> courts =
          result.map((row) => CourtModel.fromMap(row)).toList();
      return courts;
    }
    return [];
  }
}
