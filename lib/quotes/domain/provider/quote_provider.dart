import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight_it/quotes/data/quote.dart';
import 'package:highlight_it/quotes/domain/quotesLogic.dart';

class QuoteNotifier extends StateNotifier<List<Quote>> {
  final QuotesDb quotesDb;

  QuoteNotifier(this.quotesDb) : super([]);

  Future<void> fetchQuotes() async {
    final quotes = await quotesDb.fetchQuotes();
    state = quotes;
  }

  Future<void> addQuote(Quote quote) async {
    await quotesDb.addQuote(quote);
    fetchQuotes(); // Refresh the list after adding
  }

  Future<void> deleteQuote(Quote quote) async {
    await quotesDb.delteQuote(quote);
    fetchQuotes(); // Refresh the list after deletion
  }
}

final quotesProvider = StateNotifierProvider<QuoteNotifier, List<Quote>>((ref) {
  return QuoteNotifier(QuotesDb_impl());
});
