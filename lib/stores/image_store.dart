import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gemini/states/image_states.dart';
import 'package:image_picker/image_picker.dart';

class ImageStore extends ValueNotifier<ImageState> {
  ImageStore(this.imagePicker) : super(ImageInitialState());
  final ImagePicker imagePicker;

  Future<void> escolherImagens() async {
    value = ImageLoadingState();
    try {
      final result = await imagePicker.pickMultiImage();
      final uint8List = await converterParaUint8(result);
      value = ImageSuccessState(uint8List);
    } catch (e) {
      value = ImageErrorState(e.toString());
    }
  }

  Future<List<Uint8List>> converterParaUint8(List<XFile> imagens) async =>
      await imagens.map((e) => File(e.path).readAsBytes()).wait;
}
