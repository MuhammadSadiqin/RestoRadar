sealed class ResultState<T> {}

class InitialState<T> extends ResultState<T> {}

class LoadingState<T> extends ResultState<T> {}

class SuccessState<T> extends ResultState<T> {
  final T data;
  SuccessState(this.data);
}

class ErrorState<T> extends ResultState<T> {
  final String message;
  ErrorState(this.message);
}
