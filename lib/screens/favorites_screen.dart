import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/bloc/court/court_bloc.dart';
import 'package:nolatech/bloc/court/court_state.dart';
import 'package:nolatech/models/user_model.dart';
import 'package:nolatech/screens/reservation_screen.dart';
import 'package:nolatech/widgets/court_widget.dart';

class FavoritesScreen extends StatelessWidget {
  final UserModel userModel;

  const FavoritesScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: BlocBuilder<CourtBloc, CourtState>(
        builder: (context, state) {
          if (state is CourtLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is CourtLoaded) {
            return Container(
              color: Colors.white,
              height: 320,
              child: ListView.builder(
                itemCount: state.courts.length,
                itemBuilder: (context, index) {
                  final court = state.courts[index];

                  return CourtWidget(
                    court: court,
                    onReserve:
                        court.isAvailable!
                            ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ReservationPage(
                                        court: court,
                                        user: userModel,
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
    );
  }
}
