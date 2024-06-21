import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/states/image_states.dart';
import 'package:gemini/states/request_states.dart';
import 'package:gemini/stores/image_store.dart';
import 'package:gemini/stores/request_store.dart';

class HomeController {
  HomeController(this._requestStore, this._imageStore);

  final RequestStore _requestStore;
  final ImageStore _imageStore;
  ValueListenable<RequestState> get requestStore => _requestStore;
  ValueListenable<ImageState> get imageStore => _imageStore;

  Listenable get requestTextImageMerged =>
      Listenable.merge([_requestStore, _imageStore, textController]);

  Listenable get requestTextMerged =>
      Listenable.merge([_requestStore, textController]);

  late final textController = TextEditingController();

  bool get imagensSelecionadas => _imageStore.value is ImageSuccessState;

  bool get requestEmProgresso => _requestStore.value is RequestLoadingState;

  bool get envioDeImagensHabilitado =>
      imagensSelecionadas && envioTextHabilitado;

  bool get envioTextHabilitado =>
      textController.value.text.isNotEmpty && !requestEmProgresso;

  Future<void> escolherImagens() => _imageStore.escolherImagens();

  Future<void> enviarTexto() => _requestStore.enviarTexto(textController.text);

  Future<void> enviarImagens() => _requestStore.enviarImagens(
        textController.text,
        (_imageStore.value as ImageSuccessState).imageList,
      );
}
