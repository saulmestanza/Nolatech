import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/bloc/auth/auth_bloc.dart';
import 'package:nolatech/bloc/auth/auth_event.dart';
import 'package:nolatech/bloc/auth/auth_state.dart';
import 'package:nolatech/bloc/court/court_bloc.dart';
import 'package:nolatech/bloc/reservation/reservation_bloc.dart';
import 'package:nolatech/repository/auth_repository.dart';
import 'package:nolatech/repository/court_repository.dart';
import 'package:nolatech/repository/reservation_repository.dart';
import 'package:nolatech/screens/home_screen.dart';
import 'package:nolatech/screens/onboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(AuthRepository())..add(CheckAuthStatus()),
        ),
        BlocProvider(create: (_) => CourtBloc(CourtRepository())),
        BlocProvider(create: (_) => ReservationBloc(ReservationRepository())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agendamiento Cancha de Tenis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return HomeScreen(userModel: state.user);
          } else if (state is Unauthenticated) {
            return const OnboardingScreen();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
