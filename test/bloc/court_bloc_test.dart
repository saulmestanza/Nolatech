import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nolatech/bloc/court/court_bloc.dart';
import 'package:nolatech/bloc/court/court_event.dart';
import 'package:nolatech/bloc/court/court_state.dart';
import 'package:nolatech/models/court_model.dart';
import 'package:nolatech/repository/court_repository.dart';

class MockCourtRepository extends Mock implements CourtRepository {}

void main() {
  late MockCourtRepository courtRepository;
  late CourtBloc courtBloc;

  setUp(() {
    courtRepository = MockCourtRepository();
    courtBloc = CourtBloc(courtRepository);
  });

  tearDown(() {
    courtBloc.close();
  });

  group('CourtBloc', () {
    final courtList = [
      CourtModel(id: 1, title: 'Test Court', isFavorite: true),
    ];

    blocTest<CourtBloc, CourtState>(
      'emits [CourtLoading, CourtLoaded] when courts are fetched',
      build: () {
        when(courtRepository.getAllCourts()).thenAnswer((_) async => courtList);
        return courtBloc;
      },
      act: (bloc) => bloc.add(GetAllCourts()),
      expect: () => [CourtLoading(), CourtLoaded(courtList)],
    );

    blocTest<CourtBloc, CourtState>(
      'emits [CourtLoading, CourtError] when no courts found',
      build: () {
        when(courtRepository.getAllCourts()).thenAnswer((_) async => []);
        return courtBloc;
      },
      act: (bloc) => bloc.add(GetAllCourts()),
      expect:
          () => [CourtLoading(), CourtError("No Hay Canchas en este momento.")],
    );
  });
}
