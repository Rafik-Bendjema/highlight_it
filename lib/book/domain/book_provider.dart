import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight_it/book/data/book.dart';
import 'package:highlight_it/book/domain/bookDb.dart';

class BookNotifier extends StateNotifier<List<Book>> {
  final Bookdb bookdb;

  BookNotifier(this.bookdb) : super([]);

  Future<void> fetchBooks() async {
    final books = await bookdb.fetchBooks();
    state = books;
  }
}

final booksProvider = StateNotifierProvider<BookNotifier, List<Book>>((ref) {
  return BookNotifier(Bookdb_impl());
});
