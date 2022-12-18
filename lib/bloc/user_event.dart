// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

class UserEvent {}

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

class SaveAnnouncement extends UserEvent {
  Announcement announcement;
  SaveAnnouncement({
    required this.announcement,
  });
}

class ResetPassword extends UserEvent {
  final String email;

  ResetPassword(this.email);
}
