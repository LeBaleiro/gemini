import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/states/image_states.dart';
import 'package:gemini/states/request_states.dart';
import 'package:gemini/stores/image_store.dart';
import 'package:gemini/stores/request_store.dart';
import 'package:value_selectable/value_selectable.dart';

class HomeController {
  HomeController(this._$requestStore, this._$imageStore);

  final RequestStore _$requestStore;
  final ImageStore _$imageStore;
  ValueListenable<RequestState> get $requestStore => _$requestStore;
  ValueListenable<ImageState> get $imageStore => _$imageStore;

  late final $textController = TextEditingController();

  late final $envioDeImagensHabilitado = ValueSelector<bool>(
    (get) => get($imagensSelecionadas) && get($envioTextHabilitado),
  );

  late final $imagensSelecionadas =
      ValueSelector<bool>((get) => get(_$imageStore) is ImageSuccessState);

  late final $envioTextHabilitado = ValueSelector<bool>(
    (get) => get($textController).text.isNotEmpty && !get($requestEmProgresso),
  );

  late final $requestEmProgresso = ValueSelector<bool>(
    (get) => get($requestStore) is RequestLoadingState,
  );

  Future<void> escolherImagens() => _$imageStore.escolherImagens();

  Future<void> enviarTexto() =>
      _$requestStore.enviarTexto($textController.text);

  Future<void> enviarImagens() async {
    if (_$imageStore.value case ImageSuccessState successImage) {
      return _$requestStore.enviarImagens(
        $textController.text,
        successImage.imageList,
      );
    }
  }
}
