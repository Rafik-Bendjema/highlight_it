import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:highlight_it/text_block.dart';

class Recogniser {
  final File img;
  Recogniser({required this.img});

  Future<List<TextBoxIntety>> recognizeText(File imageFile) async {
    InputImage inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);

    List<TextBoxIntety> textBoxs = [];

    // Iterate through all the blocks of text
    for (TextBlock block in recognizedText.blocks) {
      // Iterate through each line in the block
      for (TextLine line in block.lines) {
        // Iterate through each word (TextElement) in the line
        for (TextElement element in line.elements) {
          print("Word found: ${element.text}");

          final String text = element.text;
          final Rect boundingBox = element.boundingBox;
          final List<Point<int>> cornerPoints = element.cornerPoints;

          textBoxs.add(TextBoxIntety(
            text: text,
            boundingBox: boundingBox,
            cornerPoints: cornerPoints,
          ));
        }
      }
    }

    textRecognizer.close();
    return textBoxs;
  }
}
