import '../../custom/custom_exceptions.dart';

class OperationEvent {
  const OperationEvent();
}

class LoadingEvent extends OperationEvent {}

class ErrorEvent extends OperationEvent {
  GenericError error;
  ErrorEvent({
    required this.error,
  });
}

class InitialEvent extends OperationEvent {
  const InitialEvent();
}

class SuccessfulEvent extends OperationEvent {}

class LoginSuccess extends OperationEvent {}

class RegisterSuccess extends OperationEvent {}
