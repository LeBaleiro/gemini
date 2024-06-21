import 'package:flutter/foundation.dart';

class MultiNotifier<TResponse> extends ValueListenable<TResponse> {
  final Listenable _listenable;
  final TResponse Function() _compute;
  MultiNotifier({
    required List<ValueListenable> valueListenables,
    required TResponse Function() compute,
  })  : _compute = compute,
        _listenable = Listenable.merge(valueListenables);

  @override
  void addListener(VoidCallback listener) => _listenable.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _listenable.removeListener(listener);

  @override
  TResponse get value => _compute();
}
