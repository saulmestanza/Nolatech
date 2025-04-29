import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nolatech/bloc/reservation/reservation_bloc.dart';
import 'package:nolatech/bloc/reservation/reservation_event.dart';
import 'package:nolatech/bloc/reservation/reservation_state.dart';
import 'package:nolatech/models/reservation_model.dart';
import 'package:nolatech/repository/reservation_repository.dart';

class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  late MockReservationRepository reservationRepository;
  late ReservationBloc reservationBloc;

  setUp(() {
    reservationRepository = MockReservationRepository();
    reservationBloc = ReservationBloc(reservationRepository);
  });

  tearDown(() {
    reservationBloc.close();
  });

  group('ReservationBloc', () {
    final reservation = ReservationModel(id: 1);

    blocTest<ReservationBloc, ReservationState>(
      'emits [ReservationLoading, ReservationLoaded] when reservation created',
      build: () {
        when(
          reservationRepository.insertReservation(any),
        ).thenAnswer((_) async {});
        return reservationBloc;
      },
      act: (bloc) => bloc.add(CreateReservation(reservation)),
      expect: () => [ReservationLoading(), isA<ReservationLoaded>()],
    );
  });
}
