import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gemini/widgets/imagem_list.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? modelResponse;

  late final textController = TextEditingController();

  late final imagePicker = ImagePicker();
  List<XFile>? imagens;

  bool selecionandoImagem = false;
  String? erroImagem;
  Future<void> escolherImagens() async {
    setState(() {
      selecionandoImagem = true;
      erroImagem = null;
    });
    try {
      final result = await imagePicker.pickMultiImage();
      setState(() {
        imagens = result;
        selecionandoImagem = false;
      });
    } catch (e) {
      setState(() {
        erroImagem = e.toString();
        selecionandoImagem = false;
      });
    }
  }

  late final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: const String.fromEnvironment('API_KEY'),
  );

  bool enviandoDadosParaGemini = false;
  String? erroGemini;

  Future<void> enviarTexto(String text) async {
    setState(() {
      enviandoDadosParaGemini = true;
      erroGemini = null;
    });
    try {
      final content = [Content.text(text)];
      final response = await model.generateContent(content);
      setState(() {
        modelResponse = response.text;
        enviandoDadosParaGemini = false;
      });
    } catch (e) {
      setState(() {
        erroGemini = e.toString();
        enviandoDadosParaGemini = false;
      });
    }
  }

  Future<void> enviarImagens(String text) async {
    setState(() {
      enviandoDadosParaGemini = true;
      erroGemini = null;
    });
    final prompt = TextPart(text);
    if (imagens == null) return;
    try {
      final fileImages =
          await imagens!.map((e) => File(e.path).readAsBytes()).wait;
      final imageParts = fileImages.map((e) => DataPart('image/png', e));
      final response = await model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      setState(() {
        modelResponse = response.text;
        enviandoDadosParaGemini = false;
      });
    } catch (e) {
      setState(() {
        erroGemini = e.toString();
        enviandoDadosParaGemini = false;
      });
    }
  }

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
              ValueListenableBuilder(
                  valueListenable: textController,
                  builder: (context, value, child) {
                    final campoVazio = value.text.isEmpty;
                    final botaoDesabilitado =
                        enviandoDadosParaGemini || campoVazio;
                    return TextButton(
                      onPressed: botaoDesabilitado
                          ? null
                          : () => enviarTexto(textController.text),
                      child: const Text('Enviar texto'),
                    );
                  }),
              const SizedBox(height: 10),
              TextButton(
                onPressed: selecionandoImagem ? null : escolherImagens,
                child: const Text('Escolher imagens'),
              ),
              const SizedBox(height: 10),
              if (erroImagem != null) ...{
                Text(erroImagem!)
              } else if (imagens != null) ...{
                ImagemList(imagens: imagens)
              } else if (selecionandoImagem) ...{
                const CircularProgressIndicator()
              },
              const SizedBox(height: 10),
              ValueListenableBuilder(
                  valueListenable: textController,
                  builder: (context, value, child) {
                    final campoVazio = value.text.isEmpty;
                    final imagemSelecionada = imagens != null;
                    final botaoDesabilitado = enviandoDadosParaGemini ||
                        !imagemSelecionada ||
                        campoVazio;
                    return TextButton(
                      onPressed: botaoDesabilitado
                          ? null
                          : () => enviarImagens(textController.text),
                      child: const Text('Enviar imagens'),
                    );
                  }),
              const SizedBox(height: 10),
              if (enviandoDadosParaGemini) ...{
                const CircularProgressIndicator()
              } else if (erroGemini != null) ...{
                Text(erroGemini!),
              } else ...{
                Text(modelResponse ?? 'Sem resposta'),
              },
            ],
          ),
        ),
      ),
    );
  }
}
