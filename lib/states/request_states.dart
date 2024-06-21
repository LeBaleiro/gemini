sealed class RequestState {}

class RequestInitialState extends RequestState {}

class RequestErrorState extends RequestState {
  final String message;

  RequestErrorState(this.message);
}

class RequestLoadingState extends RequestState {}

class RequestSuccessState extends RequestState {
  final String response;

  RequestSuccessState(this.response);
}
