class Quote {
  int? id;
  String title;
  int? page;
  int color;
  int? categoryId;

  Quote({
    this.id,
    required this.title,
    this.page,
    required this.color,
    this.categoryId,
  });

  // Convert a Quote object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book': title,
      'page': page,
      'color': color,
      'category': categoryId,
    };
  }

  // Create a Quote object from a Map object
  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] as int?,
      title: map['book'] as String,
      page: map['page'] as int?,
      color: map['color'] as int,
      categoryId: map['category'] as int?,
    );
  }
}
