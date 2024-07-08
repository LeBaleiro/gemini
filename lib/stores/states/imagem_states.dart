import 'dart:typed_data';

sealed class ImagemState {}

class ImagemStateLoading extends ImagemState {}

class ImagemStateError extends ImagemState {
  final String mensagem;

  ImagemStateError(this.mensagem);
}

class ImagemStateSuccess extends ImagemState {
  final List<Uint8List> imagens;

  ImagemStateSuccess(this.imagens);
}

class ImagemStateInitial extends ImagemState {}
