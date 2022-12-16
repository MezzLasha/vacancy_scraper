class OperationEvent {
  const OperationEvent();
}

class LoadingEvent extends OperationEvent {}

class ErrorEvent extends OperationEvent {
  Exception exception;
  ErrorEvent({
    required this.exception,
  });
}

class InitialEvent extends OperationEvent {
  const InitialEvent();
}

class SuccessfulEvent extends OperationEvent {}
