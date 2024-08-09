import 'dart:io';

import 'package:flutter/material.dart';
import 'package:highlight_it/logic/recogniser.dart';
import 'package:highlight_it/text_block.dart';

class Imageviewpage extends StatefulWidget {
  final String path;
  const Imageviewpage({super.key, required this.path});

  @override
  State<Imageviewpage> createState() => _ImageviewpageState();
}

class _ImageviewpageState extends State<Imageviewpage> {
  File? _img;
  Size? _originalImageSize;

  @override
  void initState() {
    super.initState();
    loadimg();
  }

  loadimg() async {
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
                    )
                  ],
                );
              }
              if (snapshot.hasData) {
                List<TextBoxIntety> boxes = snapshot.data!;
                if (boxes.isNotEmpty) {
                  return Center(
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double imageRatio = _originalImageSize!.width /
                            _originalImageSize!.height;
                        double widgetRatio =
                            constraints.maxWidth / constraints.maxHeight;

                        double scaleX, scaleY;
                        double offsetX = 0;
                        double offsetY = 0;

                        if (widgetRatio > imageRatio) {
                          // Widget is wider than the image
                          scaleX = scaleY = constraints.maxHeight /
                              _originalImageSize!.height;
                          offsetX = (constraints.maxWidth -
                                  (_originalImageSize!.width * scaleX)) /
                              2;
                        } else {
                          // Widget is taller than the image
                          scaleX = scaleY =
                              constraints.maxWidth / _originalImageSize!.width;
                          offsetY = (constraints.maxHeight -
                                  (_originalImageSize!.height * scaleY)) /
                              2;
                        }

                        return Stack(
                          children: [
                            Positioned(
                              left: offsetX,
                              top: offsetY,
                              width: _originalImageSize!.width * scaleX,
                              height: _originalImageSize!.height * scaleY,
                              child: Image.file(
                                _img!,
                                fit: BoxFit.contain,
                              ),
                            ),
                            ...boxes.map((box) {
                              final scaledRect = Rect.fromLTRB(
                                offsetX + box.boundingBox.left * scaleX,
                                offsetY + box.boundingBox.top * scaleY,
                                offsetX + box.boundingBox.right * scaleX,
                                offsetY + box.boundingBox.bottom * scaleY,
                              );
                              bool clicked = false;
                              return Positioned.fromRect(
                                rect: scaledRect,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      clicked = true;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: clicked
                                            ? Colors.yellow
                                            : Colors.blue, // Border color
                                        width: 2.0, // Border width
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  );
                }
              }
              if (snapshot.hasError) {
                return const Text("Error");
              }
              return const CircularProgressIndicator();
            }),
      ),
    );
  }
}
