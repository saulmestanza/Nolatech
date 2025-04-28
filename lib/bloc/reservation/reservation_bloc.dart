import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/models/reservation_model.dart';
import 'package:nolatech/repository/reservation_repository.dart';
import 'reservation_event.dart';
import 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRepository reservationRepository;
  List<ReservationModel> reservations = [];

  ReservationBloc(this.reservationRepository) : super(ReservationLoading()) {
    on<GetAllReservations>((event, emit) async {
      emit(ReservationLoading());
      reservations = await reservationRepository.getAllReservations();
      reservations.isNotEmpty
          ? emit(ReservationLoaded(reservations))
          : emit(ReservationError("No Hay Reservaciones en este momento."));
    });

    on<CreateReservation>((event, emit) async {
      emit(ReservationLoading());
      final reservation = event.reservationModel;
      await reservationRepository.insertReservation(reservation);
      reservations.add(reservation);
      emit(ReservationLoaded(reservations));
    });
  }
}
