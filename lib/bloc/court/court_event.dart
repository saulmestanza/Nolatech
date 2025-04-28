import 'package:nolatech/models/court_model.dart';

abstract class CourtEvent {}

class GetAllCourts extends CourtEvent {}

class GetAllFavoriteCourts extends CourtEvent {}

class UpdateCourtFavorite extends CourtEvent {
  final CourtModel courtModel;
  UpdateCourtFavorite(this.courtModel);
}

class UpdateCourtAvailability extends CourtEvent {
  final CourtModel courtModel;
  UpdateCourtAvailability(this.courtModel);
}
