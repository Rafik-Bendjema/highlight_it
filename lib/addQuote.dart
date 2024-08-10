import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:highlight_it/category/data/category.dart';
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
  QuotesDb quotesDb = QuotesDb_impl();
  String content = "";
  List<CategoryIntety> categories = [
    CategoryIntety(id: 1, name: 'Fiction', color: 0xFF42A5F5), // Blue color
    CategoryIntety(
        id: 2, name: 'Non-Fiction', color: 0xFF66BB6A), // Green color
    CategoryIntety(id: 3, name: 'Science', color: 0xFFFFA726), // Orange color
  ];
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _pagecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? category;
  // create some values
  Color currentColor = const Color(0xff443a49);

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      Quote q = Quote(
          title: _titlecontroller.text,
          color: currentColor.value,
          categoryId: category);
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
                              controller: TextEditingController(text: content),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return "this field can't be empty";
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(hintText: "book title"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "page number"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("color"),
                                Icon(
                                  Icons.circle,
                                  color: currentColor,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: SingleChildScrollView(
                                                  child: BlockPicker(
                                                      pickerColor: currentColor,
                                                      onColorChanged: (c) {
                                                        setState(() {
                                                          currentColor = c;
                                                        });
                                                      }),
                                                ),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text("Done"))
                                                ],
                                              ));
                                    },
                                    child: const Text("Pick"))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Autocomplete(
                              onSelected: (option) {
                                category = categories
                                    .where((c) => c.name == option)
                                    .first
                                    .id;
                              },
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                return categories
                                    .where((c) => c.name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase()))
                                    .map((c) => c.name)
                                    .toList();
                              },
                              fieldViewBuilder: (context, textEditingController,
                                  focusNode, onFieldSubmitted) {
                                return TextFormField(
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
