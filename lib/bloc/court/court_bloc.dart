import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/repository/court_repository.dart';
import 'court_event.dart';
import 'court_state.dart';

class CourtBloc extends Bloc<CourtEvent, CourtState> {
  final CourtRepository courtRepository;

  CourtBloc(this.courtRepository) : super(CourtLoading()) {
    on<GetAllCourts>((event, emit) async {
      emit(CourtLoading());
      final courts = await courtRepository.getAllCourts();
      courts.isNotEmpty
          ? emit(CourtLoaded(courts))
          : CourtError("No Hay Canchas en este momento.");
    });
  }
}
