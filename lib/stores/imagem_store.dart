import 'package:flutter/material.dart';
import 'package:gemini/stores/states/imagem_states.dart';
import 'package:image_picker/image_picker.dart';

class ImagemStore extends ValueNotifier<ImagemState> {
  final ImagePicker _imagePicker;

  ImagemStore(this._imagePicker) : super(ImagemStateInitial());

  Future<void> escolherImagens() async {
    value = ImagemStateLoading();
    try {
      final result = await _imagePicker.pickMultiImage();
      value = ImagemStateSuccess(result);
    } catch (e) {
      value = ImagemStateError(e.toString());
    }
  }
}
