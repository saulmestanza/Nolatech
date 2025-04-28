import 'package:nolatech/models/reservation_model.dart';
import 'package:nolatech/repository/auth_repository.dart';
import 'package:nolatech/repository/court_repository.dart';
import 'package:nolatech/repository/db_init.dart';
import 'package:sqflite/sqflite.dart';

class ReservationRepository extends DbInit {
  Database? _db;
  final authRepository = AuthRepository();
  final courtRepository = CourtRepository();

  Future<List<ReservationModel>> getAllReservations() async {
    _db = _db ?? await super.db;
    final result = await _db!.query('reservations');
    if (result.isNotEmpty) {
      final courts = await courtRepository.getAllCourts();
      final user = await authRepository.getLoggedUser();
      List<ReservationModel> reservations =
          result.map((row) {
            ReservationModel reservation = ReservationModel.fromMap(row);
            reservation = reservation.copyWith(
              userModel: user,
              courtModel:
                  courts
                      .where((court) => court.id == reservation.courtModel!.id)
                      .first,
            );
            return reservation;
          }).toList();
      return reservations;
    }
    return [];
  }

  Future<void> insertReservation(ReservationModel reservation) async {
    _db = _db ?? await super.db;
    await _db!.insert('reservations', reservation.toMap());
  }
}
