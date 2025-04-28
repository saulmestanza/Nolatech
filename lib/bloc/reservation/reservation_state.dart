import 'package:nolatech/models/reservation_model.dart';

abstract class ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationLoaded extends ReservationState {
  final List<ReservationModel> reservations;
  ReservationLoaded(this.reservations);
}

class ReservationError extends ReservationState {
  final String message;
  ReservationError(this.message);
}
