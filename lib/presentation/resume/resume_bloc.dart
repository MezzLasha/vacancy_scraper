import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'resume_event.dart';
part 'resume_state.dart';

class ResumeBloc extends HydratedBloc<ResumeEvent, ResumeState> {
  ResumeBloc() : super(ResumeInitial()) {
    on<ResumeEvent>((event, emit) {
      if (event is UploadResumeEvent) {
        emit(state.copyWith(filePath: event.filePath));
      } else if (event is DeleteResumeEvent) {
        emit(state.copyWith(filePath: ''));
      }
    });
  }

  @override
  ResumeState? fromJson(Map<String, dynamic> json) {
    return ResumeState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ResumeState state) {
    return state.toMap();
  }
}
