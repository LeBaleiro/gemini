import 'package:flutter/material.dart';
import 'package:gemini/home_controller.dart';
import 'package:gemini/states/home_states.dart';
import 'package:gemini/image_store.dart';
import 'package:gemini/request_store.dart';
import 'package:gemini/states/image_states.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: const String.fromEnvironment('API_KEY'),
  );
  late final imagePicker = ImagePicker();

  late final homeController = HomeController(
    RequestStore(model),
    ImageStore(imagePicker),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: homeController.textController),
              const SizedBox(height: 10),
              TextButton(
                onPressed: homeController.enviarTexto,
                child: const Text('Enviar texto'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: homeController.escolherImagens,
                child: const Text('Escolher imagens'),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                valueListenable: homeController.imageStore,
                builder: (context, value, child) {
                  return switch (value) {
                    ImageSuccessState success => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: success.imageList
                            .map((e) => Image.memory(e,
                                height: 200, fit: BoxFit.fitHeight))
                            .toList(),
                      ),
                    ImageLoadingState _ => const CircularProgressIndicator(),
                    ImageInitialState _ => const SizedBox.shrink(),
                    ImageErrorState error => Text(error.message),
                  };
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: homeController.enviarImagens,
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
