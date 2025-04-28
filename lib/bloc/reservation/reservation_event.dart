import 'package:nolatech/models/reservation_model.dart';

abstract class ReservationEvent {}

class GetAllReservations extends ReservationEvent {}

class CreateReservation extends ReservationEvent {
  final ReservationModel reservationModel;
  CreateReservation(this.reservationModel);
}
