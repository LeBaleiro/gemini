import 'package:flutter/material.dart';
import 'package:gemini/home_controller.dart';
import 'package:gemini/states/home_states.dart';
import 'package:gemini/stores/image_store.dart';
import 'package:gemini/services/gemini_service.dart';
import 'package:gemini/states/image_states.dart';
import 'package:gemini/widgets/custom_button.dart';
import 'package:gemini/widgets/image_list.dart';
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
    GeminiService(model),
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
              ValueListenableBuilder<HomeState>(
                valueListenable: homeController,
                builder: (context, value, child) => CustomButton(
                  onTap: homeController.enviarTexto,
                  label: 'Enviar texto',
                  desabilitado: value is HomeLoadingState,
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<ImageState>(
                valueListenable: homeController.imageStore,
                builder: (context, value, child) => CustomButton(
                  onTap: homeController.escolherImagens,
                  label: 'Escolher imagens',
                  desabilitado: value is ImageLoadingState,
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<ImageState>(
                valueListenable: homeController.imageStore,
                builder: (context, value, child) {
                  return switch (value) {
                    ImageSuccessState success => ImageList(success.imageList),
                    ImageLoadingState _ => const SizedBox.shrink(),
                    ImageInitialState _ => const SizedBox.shrink(),
                    ImageErrorState error => Text(error.message),
                  };
                },
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<HomeState>(
                valueListenable: homeController,
                builder: (context, value, child) => CustomButton(
                  onTap: homeController.enviarImagens,
                  label: 'Enviar imagens',
                  desabilitado: value is HomeLoadingState,
                ),
              ),
              const SizedBox(height: 10),
              ValueListenableBuilder<HomeState>(
                valueListenable: homeController,
                builder: (context, value, child) {
                  return switch (value) {
                    HomeSuccessState success => Text(success.response),
                    HomeErrorState error => Text(error.message),
                    HomeLoadingState _ => const CircularProgressIndicator(),
                    HomeInitialState _ => const SizedBox.shrink(),
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
