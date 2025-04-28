import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nolatech/bloc/court/court_bloc.dart';
import 'package:nolatech/bloc/court/court_state.dart';
import 'package:nolatech/bloc/reservation/reservation_bloc.dart';
import 'package:nolatech/bloc/reservation/reservation_state.dart';
import 'package:nolatech/models/user_model.dart';
import 'package:nolatech/screens/reservation_screen.dart';
import 'package:nolatech/widgets/court_widget.dart';
import 'package:nolatech/widgets/reservation_widget.dart';

class FeedScreen extends StatelessWidget {
  final UserModel? userModel;

  const FeedScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola ${userModel?.name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Canchas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            BlocBuilder<CourtBloc, CourtState>(
              builder: (context, state) {
                if (state is CourtLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is CourtLoaded) {
                  return Container(
                    color: Colors.white,
                    height: 320,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.courts.length,
                      itemBuilder: (context, index) {
                        final court = state.courts[index];

                        return CourtWidget(
                          imageUrl: court.imageUrl!,
                          title: court.title!,
                          type: court.type!,
                          startTime: court.startTime!,
                          endTime: court.endTime!,
                          availability: court.isAvailable!,
                          onReserve:
                              court.isAvailable!
                                  ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ReservationPage(
                                              court: court,
                                              user: userModel!,
                                            ),
                                      ),
                                    );
                                  }
                                  : null,
                        );
                      },
                    ),
                  );
                }
                return Offstage();
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Reservas programadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            BlocBuilder<ReservationBloc, ReservationState>(
              builder: (context, state) {
                if (state is ReservationLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is ReservationLoaded) {
                  return Container(
                    color: Colors.white,
                    height: 320,
                    child: ListView.builder(
                      itemCount: state.reservations.length,
                      itemBuilder: (context, index) {
                        final reservation = state.reservations[index];

                        return ReservationWidget(
                          imageUrl: reservation.courtModel?.imageUrl ?? "",
                          title: reservation.courtModel?.type ?? "",
                          userName: reservation.userModel?.name ?? "",
                          date: DateFormat(
                            'EEEE, d MMM, yyyy',
                          ).format(reservation.startTime!),
                          duration: reservation.time.toString(),
                          price:
                              (reservation.time! *
                                      reservation.courtModel!.price!)
                                  .toString(),
                        );
                      },
                    ),
                  );
                }
                if (state is ReservationError) {
                  return Center(child: Text(state.message));
                }
                return Offstage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
