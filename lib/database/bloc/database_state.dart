// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'database_bloc.dart';

enum DbStatus { loading, finished, empty }

class DatabaseState {
  List<Announcement> listOfAds;
  DbStatus status;
  DatabaseState({
    required this.listOfAds,
    required this.status,
  });

  DatabaseState copyWith({
    List<Announcement>? listOfAds,
    DbStatus? status,
  }) {
    return DatabaseState(
      listOfAds: listOfAds ?? this.listOfAds,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'listOfAds': listOfAds.map((x) => x.toMap()).toList(),
      'status': status,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'DatabaseState(listOfAds: $listOfAds, status: $status)';

  @override
  bool operator ==(covariant DatabaseState other) {
    if (identical(this, other)) return true;

    return listEquals(other.listOfAds, listOfAds) && other.status == status;
  }

  @override
  int get hashCode => listOfAds.hashCode ^ status.hashCode;
}
