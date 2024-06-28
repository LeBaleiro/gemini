sealed class RequestState {}

class RequestStateLoading extends RequestState {}

class RequestStateError extends RequestState {
  final String mensagem;
  RequestStateError(this.mensagem);
}

class RequestStateSuccess extends RequestState {
  final String respostaGemini;
  RequestStateSuccess(this.respostaGemini);
}

class RequestStateInitial extends RequestState {}
