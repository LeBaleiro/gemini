import 'package:flutter/material.dart';
import 'package:gemini/home_controller.dart';
import 'package:gemini/stores/request_store.dart';
import 'package:gemini/stores/imagem_store.dart';
import 'package:gemini/stores/states/imagem_states.dart';
import 'package:gemini/stores/states/request_state.dart';
import 'package:gemini/widgets/image_list.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? modelResponse;

  late final modelo = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: const String.fromEnvironment('API_KEY'),
  );

  late final imagePicker = ImagePicker();

  late final homeController =
      HomeController(RequestStore(modelo), ImagemStore(imagePicker));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: homeController.$textController),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: homeController.$envioTextoDesabilitado,
                builder: (context, value, child) {
                  return TextButton(
                    onPressed: value ? null : homeController.enviarTexto,
                    child: const Text('Enviar texto'),
                  );
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                  valueListenable: homeController.$selecaoDeImagemDesabilitado,
                  builder: (context, value, child) {
                    return TextButton(
                      onPressed: value ? null : homeController.escolherImagens,
                      child: const Text('Escolher imagens'),
                    );
                  }),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: homeController.$imagemStore,
                builder: (context, value, child) {
                  return switch (value) {
                    ImagemStateSuccess success =>
                      ImageList(imagens: success.imagens),
                    ImagemStateError error => Text(error.mensagem),
                    ImagemStateInitial _ => const SizedBox.shrink(),
                    ImagemStateLoading _ => const CircularProgressIndicator(),
                  };
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: homeController.$envioImagensDesabilitado,
                builder: (context, value, child) {
                  return TextButton(
                    onPressed: value ? null : homeController.enviarImagens,
                    child: const Text('Enviar imagens'),
                  );
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: homeController.$requestStore,
                builder: (context, value, child) {
                  return switch (value) {
                    RequestStateSuccess success => Text(success.respostaGemini),
                    RequestStateError error => Text(error.mensagem),
                    RequestStateInitial _ => const SizedBox.shrink(),
                    RequestStateLoading _ => const CircularProgressIndicator(),
                  };
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
