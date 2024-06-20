sealed class HomeState {}

class HomeInitialState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState(this.message);
}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final String response;

  HomeSuccessState(this.response);
}
