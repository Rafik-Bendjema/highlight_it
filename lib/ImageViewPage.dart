import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Imageviewpage extends StatefulWidget {
  final String path;
  const Imageviewpage({super.key, required this.path});

  @override
  State<Imageviewpage> createState() => _ImageviewpageState();
}

class _ImageviewpageState extends State<Imageviewpage> {
  File? _img;
  @override
  void initState() {
    checkimg();
    super.initState();
  }

  checkimg() async {
    File imageFile = File(widget.path);
    if (await imageFile.exists()) {
      setState(() {
        _img = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _img != null
            ? Image.file(_img!)
            : const Text('Image not found in cache'),
      ),
    );
  }
}
