import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:highlight_it/book/data/book.dart';
import 'package:highlight_it/book/domain/bookDb.dart';
import 'package:highlight_it/quotes/data/quote.dart';
import 'package:highlight_it/quotes/domain/quotesLogic.dart';

class Quotesview extends StatefulWidget {
  List<Quote> quotes;
  Quotesview({super.key, required this.quotes});

  @override
  State<Quotesview> createState() => _QuotesviewState();
}

class _QuotesviewState extends State<Quotesview> {
  List<Quote> quotes = [];
  QuotesDb quotesDb = QuotesDb_impl();
  Bookdb bookdb = Bookdb_impl();
  @override
  void initState() {
    quotes = widget.quotes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            return FutureBuilder<Book?>(
                future: bookdb.getBook(quotes[index].book),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("error while getting the book title"),
                    );
                  }
                  Book? data = snapshot.data;
                  print(
                      "try to get book with the id ${quotes[index].book} and got $data");
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(data.title),
                                content: Text(quotes[index].content),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("back")),
                                  TextButton(
                                      onPressed: () async {
                                        await quotesDb
                                            .delteQuote(quotes[index]);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("delete"))
                                ],
                              ));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 218, 218, 218),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data!.title),
                              Text(
                                  'page number ${quotes[index].page ?? "none"}')
                            ],
                          ),
                          Text(quotes[index].content)
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
