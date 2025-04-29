import 'package:nolatech/models/court_model.dart';
import 'package:nolatech/repository/db_init.dart';
import 'package:nolatech/repository/weather_repository.dart';
import 'package:sqflite/sqflite.dart';

class CourtRepository extends DbInit {
  final weatherRepository = WeatherRepository();
  Database? _db;

  Future<List<CourtModel>> getAllCourts() async {
    _db = _db ?? await super.db;
    final result = await _db!.query('courts');
    if (result.isNotEmpty) {
      List<CourtModel> courts =
          result.map((row) => CourtModel.fromMap(row)).toList();
      final _courts = List<CourtModel>.from([]);
      for (CourtModel court in courts) {
        final weather = await weatherRepository.getDailyPrecipitationMax(court);
        _courts.add(court.copyWith(weather: weather));
      }
      return _courts;
    }
    return [];
  }

  Future<List<CourtModel>> getAllFavoriteCourts() async {
    _db = _db ?? await super.db;
    final result = await _db!.query('courts', where: 'is_favorite = 1');
    if (result.isNotEmpty) {
      List<CourtModel> courts =
          result.map((row) => CourtModel.fromMap(row)).toList();
      final _courts = List<CourtModel>.from([]);
      for (CourtModel court in courts) {
        final weather = await weatherRepository.getDailyPrecipitationMax(court);
        _courts.add(court.copyWith(weather: weather));
      }
      return _courts;
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
