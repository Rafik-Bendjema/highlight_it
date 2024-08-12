class Quote {
  int? id;
  String content;
  int book;
  int? page;
  int? categoryId;

  Quote({
    this.id,
    required this.content,
    required this.book,
    this.page,
    this.categoryId,
  });

  // Convert a Quote object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'book': book,
      'page': page,
      'category': categoryId,
    };
  }

  // Create a Quote object from a Map object
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] as int?,
      content: map['content'] as String,
      book: map['book'] as int,
      page: map['page'] as int?,
      categoryId: map['category'] as int?,
    );
  }
}
