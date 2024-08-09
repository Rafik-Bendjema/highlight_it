class Quote {
  int? id;
  final String content;
  final String title;
  final int? page;
  final int color;
  Quote({
    required this.content,
    required this.color,
    this.page,
    required this.title,
  });
}
