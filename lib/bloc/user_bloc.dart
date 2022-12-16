import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:vacancy_scraper/models/user_model.dart';
import 'package:vacancy_scraper/repositories/fireRepo.dart';
import 'operation_events.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  FireRepository db = FireRepository();

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (kDebugMode) {
        print(event.toString());
      }

      if (event is RegisterUser) {
        emit(state.copyWith(user: event.user, operationEvent: LoadingEvent()));
        try {
          await db.registerUser(event.user);
          emit(state.copyWith(
              user: event.user, operationEvent: SuccessfulEvent()));
        } catch (e) {
          emit(state.copyWith(
              operationEvent: ErrorEvent(exception: Exception(e))));
        }
      } else if (event is LoginUser) {
        emit(state.copyWith(operationEvent: LoadingEvent()));
        try {
          User user = await db.loginUser(event.email, event.password);

          if (kDebugMode) {
            print('Logging In $user');
          }

          emit(state.copyWith(user: user, operationEvent: SuccessfulEvent()));
        } catch (e) {
          emit(state.copyWith(
              operationEvent: ErrorEvent(exception: Exception(e))));
        }
      } else if (event is LogoutUser) {
        try {
          emit(state.copyWith(
              user: UserInitial().user, operationEvent: SuccessfulEvent()));
          if (kDebugMode) {
            print('logged out');
          }
        } catch (e) {
          emit(state.copyWith(
              operationEvent: ErrorEvent(exception: Exception(e))));
        }
      } else if (event is EmitUserToHome) {
        emit(state.copyWith(
            user: event.user, operationEvent: SuccessfulEvent()));
      }
    });
  }
}
