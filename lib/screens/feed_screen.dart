import 'package:flutter/material.dart';
import 'package:nolatech/models/user_model.dart';
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
            Container(
              color: Colors.white,
              height: 320,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Canchas
                ],
              ),
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
