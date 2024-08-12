class Book {
  int? id;
  final String title;
  Book({this.id, required this.title});

  Map<String, dynamic> toMap() {
    return {"title": title};
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(id: map["id"] as int, title: map["title"] as String);
  }
}
