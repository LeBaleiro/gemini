import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gemini/stores/states/request_state.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class RequestStore extends ValueNotifier<RequestState> {
  RequestStore(this._modelo) : super(RequestStateInitial());
  final GenerativeModel _modelo;

  Future<void> enviarTexto(String text) async {
    value = RequestStateLoading();
    final content = [Content.text(text)];
    try {
      final response = await _modelo.generateContent(content);
      await Future.delayed(const Duration(seconds: 2));
      if (response.text == null || response.text!.isEmpty) {
        value = RequestStateError('resposta vazia');
        return;
      }
      value = RequestStateSuccess(response.text!);
    } catch (e) {
      value = RequestStateError(e.toString());
    }
  }

  Future<void> enviarImagens(String text, List<Uint8List> imagens) async {
    value = RequestStateLoading();
    final prompt = TextPart(text);
    try {
      final imageParts = imagens.map((e) => DataPart('image/png', e));
      final response = await _modelo.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      if (response.text == null || response.text!.isEmpty) {
        value = RequestStateError('resposta vazia');
        return;
      }
      value = RequestStateSuccess(response.text!);
    } catch (e) {
      value = RequestStateError(e.toString());
    }
  }
}
