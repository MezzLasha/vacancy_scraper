import 'package:flutter/material.dart';
import 'package:vacancy_scraper/custom/myCustomWidgets.dart';

abstract class GenericError {
  String message;

  GenericError(this.message);
}

class LoginError extends GenericError {
  LoginError(super.message);
}

class RegisterError extends GenericError {
  RegisterError(super.message);
}

class SaveAnnouncementError extends GenericError {
  SaveAnnouncementError(super.message);
}

class LogoutError extends GenericError {
  LogoutError(super.message);
}

class ResetPasswordError extends GenericError {
  ResetPasswordError(super.message);
}
