import 'package:nolatech/models/court_model.dart';

abstract class CourtState {}

class CourtLoading extends CourtState {}

class CourtLoaded extends CourtState {
  final List<CourtModel> courts;
  CourtLoaded(this.courts);
}

class CourtError extends CourtState {
  final String message;
  CourtError(this.message);
}
