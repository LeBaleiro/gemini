import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RequestStore extends ValueNotifier<String?> {
  RequestStore(this.model) : super(null);

  final GenerativeModel model;

  Future<void> enviarTexto(String text) async {
    final content = [Content.text(text)];
    final response = await model.generateContent(content);
    value = response.text;
  }

  Future<void> enviarImagens(String text, List<Uint8List> imagens) async {
    final prompt = TextPart(text);
    final imageParts = imagens.map((e) => DataPart('image/png', e));
    final response = await model.generateContent([
      Content.multi([prompt, ...imageParts])
    ]);
    value = response.text;
  }
}
