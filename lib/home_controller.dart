import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gemini/shared/computed_notifier.dart';
import 'package:gemini/states/image_states.dart';
import 'package:gemini/states/request_states.dart';
import 'package:gemini/stores/image_store.dart';
import 'package:gemini/stores/request_store.dart';

class HomeController {
  HomeController(this._$requestStore, this._$imageStore);

  final RequestStore _$requestStore;
  final ImageStore _$imageStore;
  ValueListenable<RequestState> get $requestStore => _$requestStore;
  ValueListenable<ImageState> get $imageStore => _$imageStore;

  late final $textController = TextEditingController();

  late final $envioDeImagensHabilitado = ComputedNotifier<bool>(
    valueListenables: [$envioTextHabilitado, _$imageStore],
    compute: () {
      final imagensSelecionadas = _$imageStore.value is ImageSuccessState;
      return imagensSelecionadas && $envioTextHabilitado.value;
    },
  );

  late final $envioTextHabilitado = ComputedNotifier<bool>(
    valueListenables: [_$requestStore, $textController],
    compute: () {
      final requestEmProgresso = _$requestStore.value is RequestLoadingState;
      return $textController.value.text.isNotEmpty && !requestEmProgresso;
    },
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
