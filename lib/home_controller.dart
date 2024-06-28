import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gemini/stores/imagem_store.dart';
import 'package:gemini/stores/request_store.dart';
import 'package:gemini/stores/states/imagem_states.dart';
import 'package:gemini/stores/states/request_state.dart';
import 'package:value_selectable/value_selectable.dart';

class HomeController {
  HomeController(this._$requestStore, this._$imagemStore);

  final RequestStore _$requestStore;
  final ImagemStore _$imagemStore;

  ValueListenable<RequestState> get $requestStore => _$requestStore;
  ValueListenable<ImagemState> get $imagemStore => _$imagemStore;
  late final $textController = TextEditingController();

  late final $envioImagensDesabilitado = ValueSelector<bool>(
    (get) {
      final imagemSelecionada = !get($imagemSelecionada);
      final enviando = get($enviandoParaGemini);
      final campoVazio = get($campoDeTextoVazio);
      return imagemSelecionada || enviando || campoVazio;
      return !get($imagemSelecionada) ||
          get($enviandoParaGemini) ||
          get($campoDeTextoVazio);
    },
  );

  late final $envioTextoDesabilitado = ValueSelector<bool>(
    (get) {
      final campoVazio = get($campoDeTextoVazio);
      final enviando = get($enviandoParaGemini);
      return campoVazio || enviando;
      return get($campoDeTextoVazio) || get($enviandoParaGemini);
    },
  );

  late final $campoDeTextoVazio = ValueSelector<bool>(
    (get) => get($textController).text.isEmpty,
  );
  late final $imagemSelecionada = ValueSelector<bool>(
    (get) => get(_$imagemStore) is ImagemStateSuccess,
  );
  late final $enviandoParaGemini = ValueSelector(
    (get) => get(_$requestStore) is RequestStateLoading,
  );

  late final $selecaoDeImagemDesabilitado = ValueSelector<bool>(
    (get) => get(_$imagemStore) is ImagemStateLoading,
  );

  Future<void> escolherImagens() => _$imagemStore.escolherImagens();

  Future<void> enviarTexto() =>
      _$requestStore.enviarTexto($textController.text);

  Future<void> enviarImagens() async {
    if (_$imagemStore.value case ImagemStateSuccess imagemSuccess) {
      return _$requestStore.enviarImagens(
        $textController.text,
        imagemSuccess.imagens,
      );
    }
  }
}
