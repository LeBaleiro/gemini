import 'package:flutter/material.dart';
import 'package:gemini/home_controller.dart';
import 'package:gemini/home_states.dart';
import 'package:gemini/image_controller.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final textController = TextEditingController();

  late final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: const String.fromEnvironment('API_KEY'),
  );
  late final imagePicker = ImagePicker();

  late final homeController = HomeController(model);
  late final imageController = ImageController(imagePicker);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: textController),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () =>
                    homeController.enviarTexto(textController.text),
                child: const Text('Enviar texto'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: imageController.escolherImagens,
                child: const Text('Escolher imagens'),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: imageController,
                builder: (context, value, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: value.map((e) {
                    return Image.memory(e, height: 200, fit: BoxFit.fitHeight);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => homeController.enviarImagens(
                  textController.text,
                  imageController.value,
                ),
                child: const Text('Enviar imagens'),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<HomeState>(
                  valueListenable: homeController,
                  builder: (context, value, child) {
                    return switch (value) {
                      HomeSuccessState success =>
                        Text(success.response ?? 'Sem resposta'),
                      HomeLoadingState _ => const CircularProgressIndicator(),
                      HomeInitialState _ => const SizedBox.shrink(),
                      HomeErrorState error => Text(error.message),
                    };
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
