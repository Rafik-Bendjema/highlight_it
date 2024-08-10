import 'package:highlight_it/quotes/data/quote.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/database.dart';

abstract class QuotesDb {
  Future<bool> addQuote(Quote q);
  Future<List<Quote>> fetchQuotes();
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
      return result.map((r) => Quote.fromMap(r)).toList();
    } on Exception catch (e) {
      print("error fetching quotes :  $e");
      return [];
    }
  }
}
