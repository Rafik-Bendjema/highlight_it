import 'dart:io';

import 'package:flutter/material.dart';
import 'package:highlight_it/logic/recogniser.dart';
import 'package:highlight_it/quotes/domain/quotesLogic.dart';
import 'package:highlight_it/text_block.dart';
import 'boxesPreview.dart'; // Ensure this import is correct for your project

class Imageviewpage extends StatefulWidget {
  final String path;
  const Imageviewpage({super.key, required this.path});

  @override
  State<Imageviewpage> createState() => _ImageviewpageState();
}

class _ImageviewpageState extends State<Imageviewpage> {
  File? _img;
  Size? _originalImageSize;
  QuotesDb quotesDb = QuotesDb_impl();
  @override
  void initState() {
    super.initState();
    loadimg();
  }

  loadimg() async {
    print("here is the list");
    print(await quotesDb.fetchQuotes());
    File imageFile = File(widget.path);
    if (await imageFile.exists()) {
      final size = await getImageSize(imageFile);
      setState(() {
        _img = imageFile;
        _originalImageSize = size;
      });
    }
  }

  Future<Size> getImageSize(File imageFile) async {
    final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
    return Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
  }

  Future<List<TextBoxIntety>> checkimg() async {
    if (_img != null && _originalImageSize != null) {
      Recogniser recogniser = Recogniser(img: _img!);
      List<TextBoxIntety> res = await recogniser.recognizeText(_img!);
      return res;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder<List<TextBoxIntety>>(
          future: checkimg(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Stack(
                children: [
                  _img != null
                      ? Image.file(_img!)
                      : const Text('Image not found in cache'),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
            if (snapshot.hasData) {
              List<TextBoxIntety> boxes = snapshot.data!;
              if (boxes.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageWithBoxes(
                          imageFile: _img!,
                          originalImageSize: _originalImageSize!,
                          boxes: boxes,
                        ),
                      ),
                    );
                  },
                );
              }
            }
            if (snapshot.hasError) {
              return const Text("Error");
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
