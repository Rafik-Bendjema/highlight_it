import 'package:flutter/material.dart';
import 'package:highlight_it/book/data/book.dart';
import 'package:highlight_it/book/domain/bookDb.dart';
import 'package:highlight_it/category/domain/categoryDb.dart';
import 'package:highlight_it/quotes/data/quote.dart';
import 'package:sqflite/sqflite.dart';

import '../../category/data/category.dart';
import '../../database/database.dart';
import '../presentation/QuotesView.dart';

abstract class QuotesDb {
  Future<bool> addQuote(Quote q);
  Future<List<Quote>> fetchQuotes();
  Future<bool> delteQuote(Quote q);
  Widget fetchByCategory();
  Widget fetchByBook();
}

class QuotesDb_impl extends QuotesDb {
  @override
  Future<bool> addQuote(Quote q) async {
    try {
      final db = await DatabaseImpl().database;
      await db.insert(
        'quote',
        q.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } on Exception catch (e) {
      print("error adding a quote error : $e");
      return false;
    }
  }

  @override
  Future<List<Quote>> fetchQuotes() async {
    try {
      final db = await DatabaseImpl().database;
      List<Map<String, dynamic>> result = await db.query('Quote');
      print(result);
      return result.map((r) => Quote.fromMap(r)).toList();
    } on Exception catch (e) {
      print("error fetching quotes :  $e");
      return [];
    }
  }

  @override
  Future<bool> delteQuote(Quote q) async {
    try {
      final db = await DatabaseImpl().database;
      await db.delete('Quote', where: 'id = ?', whereArgs: [q.id]);
      return true;
    } catch (e) {
      print("error deleting quote $e");
      return false;
    }
  }

  @override
  Widget fetchByCategory() {
    Categorydb categorydb = Categorydb_impl();
    QuotesDb quotesDb = QuotesDb_impl();
    return FutureBuilder<Object>(
      future: categorydb.fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("error fetching categories"),
          );
        }
        List<CategoryIntety> categories = snapshot.data as List<CategoryIntety>;
        return FutureBuilder(
          future: quotesDb.fetchQuotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("error fetching the data"),
              );
            }
            var data = snapshot.data as List<Quote>;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                List<Quote> quotes = data
                    .where(
                        (element) => element.categoryId == categories[index].id)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      if (quotes.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Quotesview(quotes: quotes),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 203, 203, 203),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(categories[index].name),
                          Text(quotes.length.toString())
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget fetchByBook() {
    Bookdb bookdb = Bookdb_impl();
    return FutureBuilder<Object>(
      future: bookdb.fetchBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("error fetching categories"),
          );
        }
        List<Book> books = snapshot.data as List<Book>;
        return FutureBuilder(
          future: fetchQuotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("error fetching the data"),
              );
            }
            var data = snapshot.data as List<Quote>;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                List<Quote> quotes = data
                    .where((element) => element.book == books[index].id)
                    .toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      if (quotes.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Quotesview(quotes: quotes),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 203, 203, 203),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(books[index].title),
                          Text(quotes.length.toString())
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
