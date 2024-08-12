import 'package:flutter/material.dart';
import 'package:highlight_it/category/data/category.dart';
import 'package:highlight_it/category/domain/categoryDb.dart';
import 'package:highlight_it/quotes/data/quote.dart';
import 'package:highlight_it/quotes/domain/quotesLogic.dart';
import 'package:highlight_it/quotes/presentation/QuotesView.dart';

class Quoteslist extends StatefulWidget {
  const Quoteslist({super.key});

  @override
  State<Quoteslist> createState() => _QuoteslistState();
}

class _QuoteslistState extends State<Quoteslist> {
  bool isCategory = true;
  QuotesDb quotesDb = QuotesDb_impl();
  Categorydb categorydb = Categorydb_impl();

  @override
  Widget build(BuildContext context) {
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
                              setState(() {
                                isCategory = !isCategory;
                              });
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
                      ? quotesDb.fetchByCategory()
                      : quotesDb.fetchByBook()),
            ],
          ),
        ),
      ),
    );
  }
}
