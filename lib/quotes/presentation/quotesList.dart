import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight_it/quotes/data/quote.dart';
import 'package:highlight_it/quotes/domain/quotesLogic.dart';
import 'package:highlight_it/quotes/presentation/QuotesView.dart';

import '../../book/data/book.dart';
import '../../book/domain/book_provider.dart';
import '../../category/data/category.dart';
import '../../category/domain/provider/category_provider.dart';
import '../domain/provider/quote_provider.dart';

class Quoteslist extends ConsumerWidget {
  const Quoteslist({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(quotesProvider);
    final categories = ref.watch(categoriesProvider);
    final books = ref.watch(booksProvider);
    final isCategory = ref.watch(isCategoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Quotes",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        const Text("sorted by : "),
                        SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(isCategoryProvider.notifier)
                                  .update((state) => !state);
                            },
                            child: Text(
                              isCategory ? "category" : "book",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: isCategory
                    ? QuotesByCategoryView(
                        categories: categories, quotes: quotes)
                    : QuotesByBookView(books: books, quotes: quotes),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final isCategoryProvider = StateProvider<bool>((ref) => true);

class QuotesByCategoryView extends StatelessWidget {
  final List<CategoryIntety> categories;
  final List<Quote> quotes;

  const QuotesByCategoryView(
      {super.key, required this.categories, required this.quotes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        List<Quote> categoryQuotes = quotes
            .where((quote) => quote.categoryId == categories[index].id)
            .toList();

        return QuoteListTile(
          title: categories[index].name,
          quotes: categoryQuotes,
        );
      },
    );
  }
}

class QuotesByBookView extends StatelessWidget {
  final List<Book> books;
  final List<Quote> quotes;

  const QuotesByBookView(
      {super.key, required this.books, required this.quotes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        List<Quote> bookQuotes =
            quotes.where((quote) => quote.book == books[index].id).toList();

        return QuoteListTile(
          title: books[index].title,
          quotes: bookQuotes,
        );
      },
    );
  }
}

class QuoteListTile extends StatelessWidget {
  final String title;
  final List<Quote> quotes;

  const QuoteListTile({super.key, required this.title, required this.quotes});

  @override
  Widget build(BuildContext context) {
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
            children: [Text(title), Text(quotes.length.toString())],
          ),
        ),
      ),
    );
  }
}
