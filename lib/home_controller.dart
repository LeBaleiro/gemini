import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/shared/computed_notifier.dart';
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

  late final textController = TextEditingController();

  late final envioDeImagensHabilitado = ComputedNotifier<bool>(
      compute: () {
        final imagensSelecionadas = _imageStore.value is ImageSuccessState;
        return imagensSelecionadas && envioTextHabilitado.value;
      },
      valueListenables: [envioTextHabilitado, _imageStore]);

  late final envioTextHabilitado = ComputedNotifier<bool>(
    compute: () {
      final requestEmProgresso = _requestStore.value is RequestLoadingState;
      return textController.value.text.isNotEmpty && !requestEmProgresso;
    },
    valueListenables: [_requestStore, textController],
  );

  Future<void> escolherImagens() => _imageStore.escolherImagens();

  Future<void> enviarTexto() => _requestStore.enviarTexto(textController.text);

  Future<void> enviarImagens() async {
    if (_imageStore.value case ImageSuccessState successImage) {
      return _requestStore.enviarImagens(
        textController.text,
        successImage.imageList,
      );
    }
  }
}
