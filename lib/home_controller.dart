import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gemini/home_states.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeController extends ValueNotifier<HomeState> {
  HomeController(this.model) : super(HomeInitialState());

  final GenerativeModel model;

  Future<void> enviarTexto(String text) async {
    final content = [Content.text(text)];
    value = HomeLoadingState();
    try {
      final response = await model.generateContent(content);
      value = HomeSuccessState(response.text);
    } catch (e) {
      value = HomeErrorState(e.toString());
    }
  }

  Future<void> enviarImagens(String text, List<Uint8List> imagens) async {
    final prompt = TextPart(text);
    final imageParts = imagens.map((e) => DataPart('image/png', e));
    value = HomeLoadingState();
    try {
      final response = await model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      value = HomeSuccessState(response.text);
    } catch (e) {
      value = HomeErrorState(e.toString());
    }
  }
}
