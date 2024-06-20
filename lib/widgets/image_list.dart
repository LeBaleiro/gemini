import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageList extends StatelessWidget {
  const ImageList(this.imagens, {super.key});

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
                width: 140,
                fit: BoxFit.fitHeight,
              ),
            ),
          )
          .toList(),
    );
  }
}
