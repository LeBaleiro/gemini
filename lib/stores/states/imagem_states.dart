import 'package:image_picker/image_picker.dart';

sealed class ImagemState {}

class ImagemStateLoading extends ImagemState {}

class ImagemStateError extends ImagemState {
  final String mensagem;

  ImagemStateError(this.mensagem);
}

class ImagemStateSuccess extends ImagemState {
  final List<XFile> imagens;

  ImagemStateSuccess(this.imagens);
}

class ImagemStateInitial extends ImagemState {}
