import 'package:highlight_it/quotes/data/quote.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/database.dart';

abstract class QuotesDb {
  Future<void> addQuote(Quote q);
}

class QuotesDb_impl extends QuotesDb {
  @override
  Future<void> addQuote(Quote q) async {
    final db = await DatabaseImpl().database;
    await db.insert(
      'quote',
      q.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
