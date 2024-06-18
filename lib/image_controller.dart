import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends ValueNotifier<List<Uint8List>> {
  ImageController(this.imagePicker) : super([]);
  final ImagePicker imagePicker;

  Future<void> escolherImagens() async {
    final result = await imagePicker.pickMultiImage();
    final uint8List = await converterParaUint8(result);
    value = uint8List;
  }

  Future<List<Uint8List>> converterParaUint8(List<XFile> imagens) async =>
      await imagens.map((e) => File(e.path).readAsBytes()).wait;
}
