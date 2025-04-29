import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nolatech/bloc/auth/auth_bloc.dart';
import 'package:nolatech/bloc/auth/auth_event.dart';
import 'package:nolatech/bloc/auth/auth_state.dart';
import 'package:nolatech/repository/auth_repository.dart';
import 'package:nolatech/models/user_model.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository authRepository;
  late AuthBloc authBloc;

  setUp(() {
    authRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    final testUser = UserModel(
      id: 1,
      name: 'Test',
      email: 'test@test.com',
      phone: '123456',
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, Authenticated] on successful login',
      build: () {
        when(
          authRepository.login("test@test.com", "123456"),
        ).thenAnswer((_) async => true);
        when(authRepository.getLoggedUser()).thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginUser('test@test.com', 'password')),
      expect: () => [AuthLoading(), Authenticated(testUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] on failed login',
      build: () {
        when(
          authRepository.login("test@test.com", "123456"),
        ).thenAnswer((_) async => false);
        when(authRepository.getLoggedUser()).thenAnswer((_) async => null);
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginUser('wrong@test.com', 'wrong')),
      expect: () => [AuthLoading(), AuthError('Credenciales inválidas.')],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [Unauthenticated] after logout',
      build: () {
        when(authRepository.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutUser()),
      expect: () => [Unauthenticated()],
    );
  });
}
