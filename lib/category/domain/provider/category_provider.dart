import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight_it/category/data/category.dart';
import 'package:highlight_it/category/domain/categoryDb.dart';

class CategoryNotifier extends StateNotifier<List<CategoryIntety>> {
  final Categorydb categorydb;

  CategoryNotifier(this.categorydb) : super([]);

  Future<void> fetchCategories() async {
    final categories = await categorydb.fetchCategories();
    state = categories;
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoryNotifier, List<CategoryIntety>>((ref) {
  return CategoryNotifier(Categorydb_impl());
});
