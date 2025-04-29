import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/models/court_model.dart';
import 'package:nolatech/repository/court_repository.dart';
import 'package:nolatech/repository/weather_repository.dart';
import 'court_event.dart';
import 'court_state.dart';

class CourtBloc extends Bloc<CourtEvent, CourtState> {
  final WeatherRepository weatherRepository = WeatherRepository();
  final CourtRepository courtRepository;
  List<CourtModel> courts = [];

  CourtBloc(this.courtRepository) : super(CourtLoading()) {
    on<GetAllCourts>((event, emit) async {
      emit(CourtLoading());
      courts = await courtRepository.getAllCourts();
      courts.isNotEmpty
          ? emit(CourtLoaded(courts))
          : emit(CourtError("No Hay Canchas en este momento."));
    });

    on<GetAllFavoriteCourts>((event, emit) async {
      emit(CourtLoading());
      final favoriteCourts = await courtRepository.getAllFavoriteCourts();
      favoriteCourts.isNotEmpty
          ? emit(CourtLoaded(favoriteCourts))
          : emit(CourtError("No Hay Canchas favoritas en este momento."));
    });

    on<UpdateCourtFavorite>((event, emit) async {
      final updateCourt = event.courtModel.copyWith(
        isFavorite: !event.courtModel.isFavorite!,
      );
      await courtRepository.updateCourt(updateCourt);
      final index = courts.indexWhere((court) => court.id == updateCourt.id);
      courts[index] = updateCourt;
      emit(CourtLoaded(courts));
    });

    on<UpdateCourtAvailability>((event, emit) async {
      final updateCourt = event.courtModel.copyWith(isAvailable: false);
      await courtRepository.updateCourt(updateCourt);
      final index = courts.indexWhere((court) => court.id == updateCourt.id);
      courts[index] = updateCourt;
      emit(CourtLoaded(courts));
    });
  }
}
