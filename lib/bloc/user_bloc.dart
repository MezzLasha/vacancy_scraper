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
        if (state.user.savedAnnouncements.contains(event.announcement)) {
          //already added, remove from list
          try {
            var list = state.user.savedAnnouncements;
            list.remove(event.announcement);
            emit(state.copyWith(
                user: state.user.copyWith(savedAnnouncementIDs: list),
                operationEvent: SuccessfulEvent()));
          } catch (e) {
            emit(state.copyWith(
                operationEvent: ErrorEvent(exception: Exception(e))));
          }
        } else {
          try {
            //not in list, add to saved
            emit(state.copyWith(
                user: state.user.copyWith(savedAnnouncementIDs: [
              ...state.user.savedAnnouncements,
              event.announcement
            ])));
          } catch (e) {
            emit(state.copyWith(
                operationEvent: ErrorEvent(exception: Exception(e))));
          }
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
