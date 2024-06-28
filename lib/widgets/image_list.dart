import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageList extends StatelessWidget {
  const ImageList({super.key, required this.imagens});

  final List<XFile> imagens;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imagens
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.file(
                File(e.path),
                height: 200,
                fit: BoxFit.fitHeight,
              ),
            ),
          )
          .toList(),
    );
  }
}
