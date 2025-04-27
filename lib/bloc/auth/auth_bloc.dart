import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nolatech/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      final isLoggedIn = await authRepository.isLoggedIn();
      final user = await authRepository.getLoggedUser();
      emit(isLoggedIn ? Authenticated(user) : Unauthenticated());
    });

    on<RegisterUser>((event, emit) async {
      emit(AuthLoading());
      final success = await authRepository.register(
        event.name,
        event.email,
        event.phone,
        event.password,
      );
      if (success) {
        await authRepository.login(event.email, event.password);
      }
      final user = await authRepository.getLoggedUser();
      emit(success ? Authenticated(user) : AuthError("Utilice otro correo."));
    });

    on<LoginUser>((event, emit) async {
      emit(AuthLoading());
      final success = await authRepository.login(event.email, event.password);
      final user = await authRepository.getLoggedUser();
      emit(
        success ? Authenticated(user) : AuthError("Credenciales inválidas."),
      );
    });

    on<LogoutUser>((event, emit) async {
      await authRepository.logout();
      emit(Unauthenticated());
    });
  }
}
