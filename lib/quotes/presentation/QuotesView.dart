import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight_it/book/data/book.dart';
import 'package:highlight_it/quotes/data/quote.dart';
import 'package:highlight_it/quotes/domain/quotesLogic.dart';

import '../../book/domain/book_provider.dart';
import '../domain/provider/quote_provider.dart';

class Quotesview extends ConsumerStatefulWidget {
  final List<Quote> quotes;

  const Quotesview({super.key, required this.quotes});

  @override
  ConsumerState<Quotesview> createState() => _QuotesviewState();
}

class _QuotesviewState extends ConsumerState<Quotesview> {
  late List<Quote> _quotes;

  @override
  void initState() {
    super.initState();
    _quotes = widget.quotes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: _quotes.length,
          itemBuilder: (context, index) {
            final book = ref.watch(booksProvider).firstWhere(
                (b) => b.id == _quotes[index].book,
                orElse: () => Book(id: 0, title: "Unknown"));

            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(book.title),
                    content: Text(_quotes[index].content),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("back")),
                      TextButton(
                          onPressed: () async {
                            await ref
                                .read(quotesProvider.notifier)
                                .deleteQuote(_quotes[index]);

                            setState(() {
                              _quotes.removeAt(index);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("delete"))
                    ],
                  ),
                );
              },
              child: Consumer(
                builder: (context, ref, child) {
                  Book thebook = ref.read(booksProvider).firstWhere(
                        (element) => element.id == _quotes[index].book,
                        orElse: () => Book(title: "unlown"),
                      );
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 218, 218, 218),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thebook.title,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.format_quote_rounded),
                            Expanded(
                              child: Text(
                                _quotes[index].content,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.format_quote_rounded),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
