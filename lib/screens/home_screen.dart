import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/bloc/auth/auth_bloc.dart';
import 'package:nolatech/bloc/auth/auth_event.dart';
import 'package:nolatech/bloc/auth/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LogoutUser());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9CE54D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            );
          },
          listener: (BuildContext context, AuthState state) {},
        ),
      ),
    );
  }
}
