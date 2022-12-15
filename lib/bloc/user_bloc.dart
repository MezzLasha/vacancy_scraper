import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vacancy_scraper/models/user_model.dart';
import 'package:vacancy_scraper/repositories/cacheRepository.dart';

import 'operation_events.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  CacheRepository db = CacheRepository();

  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) {
      if (state.user == null) {
        emit(UserInitial());
      }

      if (event is SaveUser) {
        emit(state.copyWith(user: event.user, operationEvent: LoadingEvent()));
        try {
          if (db.saveUser(event.user)) {
            emit(state.copyWith(
                user: event.user, operationEvent: SuccessfulEvent()));
          }
        } catch (e) {
          emit(state.copyWith(
              operationEvent: ErrorEvent(exception: Exception(e))));
        }
      } else if (event is DeleteUser) {
      } else if (event is LoadUser) {
        emit(state.copyWith(operationEvent: LoadingEvent()));
        try {
          emit(state.copyWith(
              user: db.getUser(), operationEvent: SuccessfulEvent()));
        } catch (e) {
          emit(state.copyWith(
              operationEvent: ErrorEvent(exception: Exception(e))));
        }
      }
    });
  }
}
