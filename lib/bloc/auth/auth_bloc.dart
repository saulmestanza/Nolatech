import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      final isLoggedIn = await authRepository.isLoggedIn();
      emit(isLoggedIn ? Authenticated() : Unauthenticated());
    });

    on<RegisterUser>((event, emit) async {
      emit(AuthLoading());
      final success = await authRepository.register(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      );
      if (success) {
        await authRepository.login(event.email, event.password);
      }
      emit(success ? Authenticated() : AuthError("Utilice otro correo."));
    });

    on<LoginUser>((event, emit) async {
      emit(AuthLoading());
      final success = await authRepository.login(event.email, event.password);
      emit(success ? Authenticated() : AuthError("Credenciales inválidas."));
    });

    on<LogoutUser>((event, emit) async {
      await authRepository.logout();
      emit(Unauthenticated());
    });
  }
}
