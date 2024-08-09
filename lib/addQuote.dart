import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Addquote extends StatefulWidget {
  const Addquote({super.key});

  @override
  State<Addquote> createState() => _AddquoteState();
}

class _AddquoteState extends State<Addquote> {
  List<String> categories = ["romance", "displine", "happy", "sad", "hehe"];
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _pagecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? category;
  // create some values
  Color currentColor = const Color(0xff443a49);

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                            decoration:
                                const InputDecoration(hintText: "page number"),
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
                            optionsBuilder: (textediting) {
                              return categories
                                  .where((c) => c.contains(textediting.text));
                            },
                            fieldViewBuilder: (context, textEditingController,
                                focusNode, onFieldSubmitted) {
                              return TextFormField(
                                controller: textEditingController,
                                onFieldSubmitted: (s) {
                                  onFieldSubmitted;
                                },
                                focusNode: focusNode,
                                decoration:
                                    const InputDecoration(hintText: "category"),
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
    );
  }
}
