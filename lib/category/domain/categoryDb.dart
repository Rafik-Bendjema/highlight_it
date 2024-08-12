import 'package:highlight_it/category/data/category.dart';
import 'package:highlight_it/database/database.dart';
import 'package:sqflite/sqflite.dart';

abstract class Categorydb {
  Future<int?> addCategory(CategoryIntety c);
  Future<List<CategoryIntety>> fetchCategories();
}

class Categorydb_impl extends Categorydb {
  @override
  Future<int?> addCategory(CategoryIntety c) async {
    Database db = await DatabaseImpl().database;

    try {
      int id = await db.insert('category', c.toMap());
      print("category created");
      return id;
    } catch (e) {
      print("error adding a quote $e");
      return null;
    }
  }

  @override
  Future<List<CategoryIntety>> fetchCategories() async {
    Database db = await DatabaseImpl().database;
    try {
      List<Map<String, dynamic>> result = await db.query('category');
      List<CategoryIntety> categories =
          result.map((e) => CategoryIntety.fromMap(e)).toList();
      return categories;
    } catch (e) {
      print("error fetching categories $e");
      return [];
    }
  }
}
