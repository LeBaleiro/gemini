import 'dart:typed_data';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  GeminiService(this.model);

  final GenerativeModel model;

  Future<String?> enviarTexto(String text) async {
    final content = [Content.text(text)];
    final response = await model.generateContent(content);
    return response.text;
  }

  Future<String?> enviarImagens(String text, List<Uint8List> imagens) async {
    final prompt = TextPart(text);
    final imageParts = imagens.map((e) => DataPart('image/png', e));
    final response = await model.generateContent([
      Content.multi([prompt, ...imageParts])
    ]);
    return response.text;
  }
}
