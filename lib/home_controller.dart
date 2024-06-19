import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gemini/image_store.dart';
import 'package:gemini/request_store.dart';
import 'package:gemini/states/home_states.dart';
import 'package:gemini/states/image_states.dart';

class HomeController extends ValueNotifier<HomeState> {
  HomeController(this._requestStore, this._imageStore)
      : super(HomeInitialState());

  final RequestStore _requestStore;
  final ImageStore _imageStore;
  ValueListenable<ImageState> get imageStore => _imageStore;

  late final textController = TextEditingController();

  Future<void> escolherImagens() async => await _imageStore.escolherImagens();

  Future<void> enviarTexto() async {
    value = HomeLoadingState();
    try {
      await _requestStore.enviarTexto(textController.text);
      value = HomeSuccessState(_requestStore.value);
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
      await _requestStore.enviarImagens(
        textController.text,
        (_imageStore.value as ImageSuccessState).imageList,
      );
      value = HomeSuccessState(_requestStore.value);
    } catch (e) {
      value = HomeErrorState(e.toString());
    }
  }
}
