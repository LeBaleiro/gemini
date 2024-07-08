import 'dart:io';
import 'dart:typed_data';

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
      final uint8List = await converterParaUint8(result);
      value = ImagemStateSuccess(uint8List);
    } catch (e) {
      value = ImagemStateError(e.toString());
    }
  }

  Future<List<Uint8List>> converterParaUint8(List<XFile> imagens) async =>
      await imagens.map((e) => File(e.path).readAsBytes()).wait;
}
