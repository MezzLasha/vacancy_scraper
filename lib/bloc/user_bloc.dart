// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:vacancy_scraper/models/announcement.dart';

import 'package:vacancy_scraper/models/user_model.dart';
import 'package:vacancy_scraper/repositories/fireRepo.dart';

import 'operation_events.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends HydratedBloc<UserEvent, UserState> {
  FireRepository db;

  UserBloc(
    this.db,
  ) : super(UserState(
            user: User(
                name: '',
                email: '',
                password: '',
                jobCategory: '',
                savedAnnouncements: []))) {
    on<UserEvent>((event, emit) async {
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
        // emit(state.copyWith(operationEvent: LoadingEvent()));
        try {
          User user = await db.loginUser(event.email, event.password);

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
      } else if (event is ResetPassword) {
        try {
          await db.resetPassword(event.email);

          emit(state.copyWith(
              user: UserInitial().user, operationEvent: SuccessfulEvent()));
          if (kDebugMode) {
            print('logged out');
          }
        } catch (e) {
          emit(state.copyWith(
              operationEvent: ErrorEvent(exception: Exception(e))));
        }
      } else if (event is SaveAnnouncement) {
        try {
          List<Announcement> newAnnouncements =
              await db.saveAnnouncement(event.announcement, state.user);

          emit(state.copyWith(
              user: state.user.copyWith(savedAnnouncements: newAnnouncements),
              operationEvent: SuccessfulEvent()));
        } catch (e) {
          emit(state.copyWith(
              operationEvent: ErrorEvent(exception: e as Exception)));
        }
      }
    });
  }

  @override
  UserState? fromJson(Map<String, dynamic> json) {
    return UserState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(UserState state) {
    return state.toMap();
  }
}
