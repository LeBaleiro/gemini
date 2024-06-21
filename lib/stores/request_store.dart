import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gemini/services/gemini_service.dart';
import 'package:gemini/states/request_states.dart';

class RequestStore extends ValueNotifier<RequestState> {
  RequestStore(this._geminiService) : super(RequestInitialState());
  final GeminiService _geminiService;

  Future<void> enviarTexto(String text) async {
    value = RequestLoadingState();
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await _geminiService.enviarTexto(text);
      if (response == null || response.isEmpty) {
        value = RequestErrorState('Sem resposta');
        return;
      }
      value = RequestSuccessState(response);
    } catch (e) {
      value = RequestErrorState(e.toString());
    }
  }

  Future<void> enviarImagens(String text, List<Uint8List> imagens) async {
    value = RequestLoadingState();
    await Future.delayed(const Duration(seconds: 2));
    try {
      final response = await _geminiService.enviarImagens(text, imagens);
      if (response == null || response.isEmpty) {
        value = RequestErrorState('Sem resposta');
        return;
      }
      value = RequestSuccessState(response);
    } catch (e) {
      value = RequestErrorState(e.toString());
    }
  }
}
