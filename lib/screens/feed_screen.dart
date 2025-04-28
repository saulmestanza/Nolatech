import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/bloc/court/court_bloc.dart';
import 'package:nolatech/bloc/court/court_event.dart';
import 'package:nolatech/bloc/court/court_state.dart';
import 'package:nolatech/models/user_model.dart';
import 'package:nolatech/widgets/court_widget.dart';

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
                  context.read<CourtBloc>().add(GetAllCourts());
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
                          imageUrl: court.imageUrl,
                          title: court.title,
                          type: court.type,
                          startTime: court.startTime,
                          endTime: court.endTime,
                          availability: court.isAvailable,
                          onReserve:
                              court.isAvailable
                                  ? () {
                                    //
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
            // Reservas List
          ],
        ),
      ),
    );
  }
}
