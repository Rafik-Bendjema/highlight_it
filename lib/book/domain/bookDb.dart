import 'package:highlight_it/book/data/book.dart';

import '../../database/database.dart';

abstract class Bookdb {
  Future<List<Book>> fetchBooks();
  Future<int?> addBook(Book b);
  Future<Book?> getBook(int id);
}

class Bookdb_impl extends Bookdb {
  @override
  Future<List<Book>> fetchBooks() async {
    try {
      final db = await DatabaseImpl().database;
      List<Map<String, dynamic>> query = await db.query('book');
      List<Book> books = query.map((q) => Book.fromMap(q)).toList();
      return books;
    } catch (e) {
      print("error fetching books $e");
      return [];
    }
  }

  @override
  Future<Book?> getBook(int id) async {
    try {
      final db = await DatabaseImpl().database;
      List<Map<String, dynamic>> query =
          await db.query('book', where: "id = ?", whereArgs: [id]);
      print(" here is the reuslt of the get $query");
      if (query.isEmpty) {
        return null;
      }
      Book theBook = Book.fromMap(query.first);
      return theBook;
    } catch (e) {
      print("error getting the book  $e");
      return null;
    }
  }

  @override
  Future<int?> addBook(Book b) async {
    try {
      final db = await DatabaseImpl().database;
      int id = await db.insert('book', b.toMap());
      return id;
    } catch (e) {
      print("error adding a book $e");
      return null;
    }
  }
}
