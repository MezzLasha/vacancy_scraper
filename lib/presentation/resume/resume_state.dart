part of 'resume_bloc.dart';

class ResumeState {
  String filePath = '';
  ResumeState({
    required this.filePath,
  });

  ResumeState copyWith({
    String? filePath,
  }) {
    return ResumeState(
      filePath: filePath ?? this.filePath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'filePath': filePath,
    };
  }

  factory ResumeState.fromMap(Map<String, dynamic> map) {
    return ResumeState(
      filePath: map['filePath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResumeState.fromJson(String source) =>
      ResumeState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ResumeState(filePath: $filePath)';

  @override
  bool operator ==(covariant ResumeState other) {
    if (identical(this, other)) return true;

    return other.filePath == filePath;
  }

  @override
  int get hashCode => filePath.hashCode;
}

class ResumeInitial extends ResumeState {
  ResumeInitial() : super(filePath: '');
}
