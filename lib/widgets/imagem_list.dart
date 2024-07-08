import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagemList extends StatelessWidget {
  const ImagemList({super.key, required this.imagens});
  final List<Uint8List> imagens;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imagens
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.memory(
                e,
                height: 200,
                width: 150,
                fit: BoxFit.fitHeight,
              ),
            ),
          )
          .toList(),
    );
  }
}
