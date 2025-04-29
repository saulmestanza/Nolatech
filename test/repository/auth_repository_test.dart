import 'package:flutter_test/flutter_test.dart';
import 'package:nolatech/repository/auth_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late AuthRepository authRepository;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    authRepository = AuthRepository();
    await authRepository.db; // initialize db
  });

  test('register and login user', () async {
    final result = await authRepository.register(
      'Test',
      'test@test.com',
      '123456',
      'password123',
    );
    expect(result, true);

    final loginSuccess = await authRepository.login(
      'test@test.com',
      'password123',
    );
    expect(loginSuccess, true);

    final user = await authRepository.getLoggedUser();
    expect(user?.email, 'test@test.com');
  });

  test('failed login with wrong credentials', () async {
    final loginSuccess = await authRepository.login(
      'wrong@test.com',
      'wrongpassword',
    );
    expect(loginSuccess, false);
  });
}
