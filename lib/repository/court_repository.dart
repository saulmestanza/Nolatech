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

  Future<List<CourtModel>> getAllFavoriteCourts() async {
    _db = _db ?? await super.db;
    final result = await _db!.query('courts', where: 'is_favorite = 1');
    if (result.isNotEmpty) {
      List<CourtModel> courts =
          result.map((row) => CourtModel.fromMap(row)).toList();
      return courts;
    }
    return [];
  }

  Future<void> updateCourt(CourtModel court) async {
    _db = _db ?? await super.db;
    await _db!.update(
      'courts',
      court.toMap(),
      where: 'id = ?',
      whereArgs: [court.id],
    );
  }
}
