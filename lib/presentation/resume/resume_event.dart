part of 'resume_bloc.dart';

abstract class ResumeEvent extends Equatable {
  const ResumeEvent();

  @override
  List<Object> get props => [];
}

class DeleteResumeEvent extends ResumeEvent {}

class UploadResumeEvent extends ResumeEvent {
  final String filePath;

  const UploadResumeEvent(this.filePath);
}
