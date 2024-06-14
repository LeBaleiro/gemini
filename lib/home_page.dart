import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? modelResponse;

  late final controller = TextEditingController();

  late final imagePicker = ImagePicker();
  List<XFile>? imagens;

  Future<void> escolherImagens() async {
    final result = await imagePicker.pickMultiImage();
    setState(() => imagens = result);
  }

  Future<void> enviarTexto(String text) async {}

  Future<void> enviarImagens(String text) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => enviarTexto(controller.text),
                child: const Text('Enviar texto'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: escolherImagens,
                child: const Text('Escolher imagens'),
              ),
              const SizedBox(height: 10),
              if (imagens != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imagens!
                      .map(
                        (e) => Image.file(
                          File(e.path),
                          height: 200,
                          fit: BoxFit.fitHeight,
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => enviarImagens(controller.text),
                child: const Text('Enviar imagens'),
              ),
              const SizedBox(height: 10),
              Text(modelResponse ?? 'Sem resposta'),
            ],
          ),
        ),
      ),
    );
  }
}
