// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'database_bloc.dart';

@immutable
abstract class DatabaseEvent {}

class DatabaseLoadHome extends DatabaseEvent {}

class DatabaseRefresh extends DatabaseEvent {}

class DatabaseGetDetailed extends DatabaseEvent {
  final Announcement announcement;
  DatabaseGetDetailed({
    required this.announcement,
  });
}
