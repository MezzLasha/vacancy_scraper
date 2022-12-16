// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'user_bloc.dart';

class UserState {
  final User user;
  final OperationEvent operationEvent;
  UserState({
    required this.user,
    required this.operationEvent,
  });

  UserState copyWith({
    User? user,
    OperationEvent? operationEvent,
  }) {
    return UserState(
      user: user ?? this.user,
      operationEvent: operationEvent ?? this.operationEvent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'operationEvent': '',
    };
  }

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
        user: User.fromMap(map['user'] as Map<String, dynamic>),
        operationEvent: const InitialEvent());
  }

  String toJson() => json.encode(toMap());

  factory UserState.fromJson(String source) =>
      UserState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserState(user: $user, operationEvent: $operationEvent)';

  @override
  bool operator ==(covariant UserState other) {
    if (identical(this, other)) return true;

    return other.user == user && other.operationEvent == operationEvent;
  }

  @override
  int get hashCode => user.hashCode ^ operationEvent.hashCode;
}

class UserInitial extends UserState {
  UserInitial()
      : super(
            user: User(
                email: '',
                jobCategory: '',
                name: '',
                password: '',
                savedAnnouncements: []),
            operationEvent: const InitialEvent());
}
