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
      child: Padding(
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
            SizedBox(
              height: 280,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CourtWidget(
                    imageUrl: 'https://your-tennis-court-image.jpg',
                    title: 'Epic Box',
                    type: 'Cancha tipo A',
                    date: '9 de julio 2024',
                    availability: 'Disponible',
                    timeRange: '7:00 am a 4:00 pm',
                    onReserve: () {},
                  ),
                  CourtWidget(
                    imageUrl: 'https://your-tennis-court-image-2.jpg',
                    title: 'Sport Box',
                    type: 'Cancha tipo B',
                    date: '10 de julio 2024',
                    availability: 'No disponible',
                    timeRange: '',
                    onReserve: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Reservas programadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ReservationWidget(
              imageUrl: 'https://your-reservation-image.jpg',
              title: 'Epic Box',
              date: '6 de julio 2024',
              userName: 'Andrea Gómez',
              duration: '2 horas',
              price: '\$50',
            ),
            const SizedBox(height: 12),
            ReservationWidget(
              imageUrl: 'https://your-reservation-image.jpg',
              title: 'Epic Box',
              date: '7 de julio 2024',
              userName: 'Andrea Gómez',
              duration: '1 hora',
              price: '\$30',
            ),
          ],
        ),
      ),
    );
  }
}
