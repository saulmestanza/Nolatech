abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class RegisterUser extends AuthEvent {
  final String name, email, phone, password;
  RegisterUser(this.name, this.email, this.phone, this.password);
}

class LoginUser extends AuthEvent {
  final String email, password;
  LoginUser(this.email, this.password);
}

class LogoutUser extends AuthEvent {}
