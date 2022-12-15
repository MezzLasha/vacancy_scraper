// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class RegisterUser extends UserEvent {
  final User user;

  RegisterUser(this.user);
}

class LoginUser extends UserEvent {
  final String email;
  final String password;

  LoginUser(
    this.email,
    this.password,
  );
}

class LogoutUser extends UserEvent {}

class EmitUserToHome extends UserEvent {
  final User user;

  EmitUserToHome(this.user);
}
