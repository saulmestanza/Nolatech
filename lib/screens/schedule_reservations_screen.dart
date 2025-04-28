import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nolatech/bloc/reservation/reservation_bloc.dart';
import 'package:nolatech/bloc/reservation/reservation_state.dart';
import 'package:nolatech/widgets/reservation_widget.dart';

class ScheduleReservationScreen extends StatelessWidget {
  const ScheduleReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF97BF0F),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                //
              },
              child: Text(
                'Programar Reserva',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Mis Reservas",
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
                            (reservation.time! * reservation.courtModel!.price!)
                                .toString(),
                      );
                    },
                  ),
                );
              }
              return Offstage();
            },
          ),
        ],
      ),
    );
  }
}
