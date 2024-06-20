import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gemini/stores/image_store.dart';
import 'package:gemini/services/gemini_service.dart';
import 'package:gemini/states/home_states.dart';
import 'package:gemini/states/image_states.dart';

class HomeController extends ValueNotifier<HomeState> {
  HomeController(this._geminiService, this._imageStore)
      : super(HomeInitialState());

  final GeminiService _geminiService;
  final ImageStore _imageStore;
  ValueListenable<ImageState> get imageStore => _imageStore;

  late final textController = TextEditingController();

  Future<void> escolherImagens() async => await _imageStore.escolherImagens();

  Future<void> enviarTexto() async {
    value = HomeLoadingState();
    try {
      final response = await _geminiService.enviarTexto(textController.text);
      if (response == null || response.isEmpty) {
        value = HomeErrorState('Sem resposta');
        return;
      }
      value = HomeSuccessState(response);
    } catch (e) {
      value = HomeErrorState(e.toString());
    }
  }

  Future<void> enviarImagens() async {
    value = HomeLoadingState();
    if (_imageStore.value is! ImageSuccessState) {
      value = HomeErrorState('Imagem não selecionada');
      return;
    }
    try {
      final response = await _geminiService.enviarImagens(
        textController.text,
        (_imageStore.value as ImageSuccessState).imageList,
      );
      if (response == null || response.isEmpty) {
        value = HomeErrorState('Sem resposta');
        return;
      }
      value = HomeSuccessState(response);
    } catch (e) {
      value = HomeErrorState(e.toString());
    }
  }
}
