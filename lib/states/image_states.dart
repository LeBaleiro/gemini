import 'dart:typed_data';

sealed class ImageState {}

class ImageInitialState extends ImageState {}

class ImageErrorState extends ImageState {
  final String message;

  ImageErrorState(this.message);
}

class ImageLoadingState extends ImageState {}

class ImageSuccessState extends ImageState {
  final List<Uint8List> imageList;

  ImageSuccessState(this.imageList);
}
