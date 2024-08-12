import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:highlight_it/book/data/book.dart';
import 'package:highlight_it/book/domain/bookDb.dart';
import 'package:highlight_it/category/data/category.dart';
import 'package:highlight_it/category/domain/categoryDb.dart';
import 'package:highlight_it/main.dart';
import 'package:highlight_it/quotes/data/quote.dart';
import 'package:highlight_it/quotes/domain/quotesLogic.dart';

class Addquote extends StatefulWidget {
  final String content;
  const Addquote({super.key, required this.content});

  @override
  State<Addquote> createState() => _AddquoteState();
}

class _AddquoteState extends State<Addquote> {
  final Categorydb _categorydb = Categorydb_impl();
  QuotesDb quotesDb = QuotesDb_impl();
  Bookdb bookdb = Bookdb_impl();
  String content = "";
  List<CategoryIntety> categories = [];
  List<Book> books = [];

  final TextEditingController _pagecontroller = TextEditingController();
  String? categoryVal;
  String? bookVal;
  final _formKey = GlobalKey<FormState>();
  int? book;
  int? category;
  // create some values
  Color currentColor = const Color(0xff443a49);

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (category == null && categoryVal != null) {
        CategoryIntety c =
            CategoryIntety(name: categoryVal!, color: Colors.grey.value);
        category = await _categorydb.addCategory(c);
        print(
            "---------------------------------------------/nhere is the category id $category  --------------------------------------------/n");
      }
      if (book == null && bookVal != null) {
        Book b = Book(title: bookVal!);
        book = await bookdb.addBook(b);
        print(
            "---------------------------------------------/nhere is the book id $b  --------------------------------------------/n");
        if (book == null) {
          showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                    title: Text("ERROR"),
                    content: Text("erorr adding a book "),
                  ));
          return;
        }
      }

      Quote q =
          Quote(book: book!, categoryId: category, content: widget.content);
      bool res = await quotesDb.addQuote(q);
      if (res) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MyApp()));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("error adding quote"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("bakc"))
                  ],
                ));
      }
    }
  }

  @override
  void initState() {
    content = widget.content;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 218, 218, 218),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: MediaQuery.of(context).size.height * 0.8,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "quote",
                                      style: TextStyle(fontSize: 18),
                                    ))),
                            TextField(
                              readOnly: true,
                              maxLines: 3,
                              minLines: 1,
                              controller: TextEditingController(text: content),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Autocomplete(
                              onSelected: (option) async {
                                book = books
                                    .where((c) => c.title == option)
                                    .first
                                    .id;
                                print(
                                    "here is the book name $option and the id $book");
                              },
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) async {
                                books = await bookdb.fetchBooks();
                                return books
                                    .where((c) => c.title
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()))
                                    .map((c) => c.title)
                                    .toList();
                              },
                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                return TextFormField(
                                  onSaved: (newValue) async {
                                    //create category if it's null
                                    if (newValue != null &&
                                        newValue.isNotEmpty) {
                                      bookVal = newValue;
                                    }
                                  },
                                  controller: textEditingController,
                                  onFieldSubmitted: (s) {
                                    onFieldSubmitted;
                                  },
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return "this field can't be empty";
                                    }
                                    return null;
                                  },
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                      hintText: "book title"),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _pagecontroller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "page number"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Autocomplete(
                              onSelected: (option) async {
                                category = categories
                                    .where((c) => c.name == option)
                                    .first
                                    .id;
                                print(
                                    "here is the category name $option and the id $category");
                              },
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) async {
                                categories =
                                    await _categorydb.fetchCategories();
                                return categories
                                    .where((c) => c.name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase()))
                                    .map((c) => c.name)
                                    .toList();
                              },
                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                return TextFormField(
                                  onSaved: (newValue) async {
                                    //create category if it's null
                                    if (newValue != null &&
                                        newValue.isNotEmpty) {
                                      categoryVal = newValue;
                                    }
                                  },
                                  controller: textEditingController,
                                  onFieldSubmitted: (s) {
                                    onFieldSubmitted;
                                  },
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                      hintText: "category"),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Center(
                          child: TextButton(
                              onPressed: () async {
                                await _submit();
                              },
                              child: const Text("save")),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
