import 'dart:math';
import 'dart:ui';

class TextBoxIntety {
  final String text;
  final Rect boundingBox;
  final List<Point<int>> cornerPoints;

  TextBoxIntety(
      {required this.text,
      required this.boundingBox,
      required this.cornerPoints});
}
