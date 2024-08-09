import 'dart:io';
import 'package:flutter/material.dart';
import 'package:highlight_it/text_block.dart';

class ImageWithBoxes extends StatefulWidget {
  final File imageFile;
  final Size originalImageSize;
  final List<TextBoxIntety> boxes;

  const ImageWithBoxes({
    super.key,
    required this.imageFile,
    required this.originalImageSize,
    required this.boxes,
  });

  @override
  _ImageWithBoxesState createState() => _ImageWithBoxesState();
}

class _ImageWithBoxesState extends State<ImageWithBoxes> {
  List<TextBoxIntety> _highlightedBoxes = [];
  final List<Offset> _fingerPath = [];
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image with Boxes')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double imageRatio = widget.originalImageSize.width /
                widget.originalImageSize.height;
            double widgetRatio = constraints.maxWidth / constraints.maxHeight;

            double scaleX, scaleY;
            double offsetX = 0;
            double offsetY = 0;

            if (widgetRatio > imageRatio) {
              scaleX = scaleY =
                  constraints.maxHeight / widget.originalImageSize.height;
              offsetX = (constraints.maxWidth -
                      (widget.originalImageSize.width * scaleX)) /
                  2;
            } else {
              scaleX = scaleY =
                  constraints.maxWidth / widget.originalImageSize.width;
              offsetY = (constraints.maxHeight -
                      (widget.originalImageSize.height * scaleY)) /
                  2;
            }

            return GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _fingerPath.add(details.localPosition);
                  _highlightedBoxes = widget.boxes.where((box) {
                    final scaledRect = Rect.fromLTRB(
                      offsetX + box.boundingBox.left * scaleX,
                      offsetY + box.boundingBox.top * scaleY,
                      offsetX + box.boundingBox.right * scaleX,
                      offsetY + box.boundingBox.bottom * scaleY,
                    );
                    return _pathIntersectsRect(_fingerPath, scaledRect);
                  }).toList();

                  // Update the result variable
                  result = _highlightedBoxes.map((box) => box.text).join(' ');
                });
              },
              child: Stack(
                children: [
                  Positioned(
                    left: offsetX,
                    top: offsetY,
                    width: widget.originalImageSize.width * scaleX,
                    height: widget.originalImageSize.height * scaleY,
                    child: Image.file(
                      widget.imageFile,
                      fit: BoxFit.contain,
                    ),
                  ),
                  ...widget.boxes.map((box) {
                    final scaledRect = Rect.fromLTRB(
                      offsetX + box.boundingBox.left * scaleX,
                      offsetY + box.boundingBox.top * scaleY,
                      offsetX + box.boundingBox.right * scaleX,
                      offsetY + box.boundingBox.bottom * scaleY,
                    );
                    bool isHighlighted = _highlightedBoxes.contains(box);

                    return Positioned.fromRect(
                      rect: scaledRect,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isHighlighted ? Colors.yellow : Colors.blue,
                            width: 2.0,
                          ),
                        ),
                      ),
                    );
                  }),
                  // Display the result on the screen (optional)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        result,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  bool _pathIntersectsRect(List<Offset> path, Rect rect) {
    for (int i = 0; i < path.length - 1; i++) {
      final start = path[i];
      final end = path[i + 1];
      if (_lineIntersectsRect(start, end, rect)) {
        return true;
      }
    }
    return false;
  }

  bool _lineIntersectsRect(Offset p1, Offset p2, Rect rect) {
    return rect.contains(p1) ||
        rect.contains(p2) ||
        _lineIntersectsRectSide(
            p1, p2, rect.left, rect.top, rect.left, rect.bottom) ||
        _lineIntersectsRectSide(
            p1, p2, rect.left, rect.top, rect.right, rect.top) ||
        _lineIntersectsRectSide(
            p1, p2, rect.right, rect.top, rect.right, rect.bottom) ||
        _lineIntersectsRectSide(
            p1, p2, rect.left, rect.bottom, rect.right, rect.bottom);
  }

  bool _lineIntersectsRectSide(
      Offset p1, Offset p2, double x1, double y1, double x2, double y2) {
    final dx1 = p2.dx - p1.dx;
    final dy1 = p2.dy - p1.dy;
    final dx2 = x2 - x1;
    final dy2 = y2 - y1;
    final det = dx1 * dy2 - dy1 * dx2;
    if (det == 0) {
      return false; // lines are parallel
    }
    final u = ((x1 - p1.dx) * dy1 - (y1 - p1.dy) * dx1) / det;
    final v = ((x1 - p1.dx) * dy2 - (y1 - p1.dy) * dx2) / det;
    return u >= 0 && u <= 1 && v >= 0 && v <= 1;
  }
}
