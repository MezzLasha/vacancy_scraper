import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:vacancy_scraper/models/announcement.dart';
import 'package:vacancy_scraper/repositories/databaseRepo.dart';

import 'package:flutter/foundation.dart';
part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseRepository databaseRepository;
  DatabaseBloc(
    this.databaseRepository,
  ) : super(DatabaseState(listOfAds: [], status: DbStatus.empty)) {
    on<DatabaseEvent>((event, emit) async {
      if (event is DatabaseLoadHome) {
        emit(state.copyWith(status: DbStatus.loading));
        await databaseRepository.getHomeAnnouncements().then((value) {
          emit(state.copyWith(listOfAds: value, status: DbStatus.finished));
        });
      } else if (event is DatabaseRefresh) {
        emit(state.copyWith(status: DbStatus.loading));
        await databaseRepository.getHomeAnnouncements().then((value) {
          emit(state.copyWith(listOfAds: value, status: DbStatus.finished));
        });
      } else if (event is DatabaseGetDetailed) {
        Announcement oldAd = event.announcement;
        var index = state.listOfAds.indexOf(oldAd);
        List<Announcement> list = state.listOfAds;
        print(list);
        await databaseRepository.getDetailedAd(oldAd).then((value) {
          list[index] = value;
          emit(state.copyWith(listOfAds: list, status: DbStatus.finished));
        });
      }
    });
  }
}
