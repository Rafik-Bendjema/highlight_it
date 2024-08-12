class CategoryIntety {
  int? id;
  String name;
  int color;

  CategoryIntety({
    this.id,
    required this.name,
    required this.color,
  });

  // Convert a Category object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'color': color,
    };
  }

  // Create a Category object from a Map object
  factory CategoryIntety.fromMap(Map<String, dynamic> map) {
    return CategoryIntety(
      id: map['id'] as int?,
      name: map['name'] as String,
      color: map['color'] as int,
    );
  }
}
