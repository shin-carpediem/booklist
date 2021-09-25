import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_book_model.dart';

// ignore: use_key_in_widget_constructors
class AddBookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddBookModel>(
        create: (_) => AddBookModel(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('本を追加'),
          ),
          body: Center(
            child: Consumer<AddBookModel>(builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: '本のタイトル',
                      ),
                      onChanged: (text) {
                        model.title = text;
                      },
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: '本の著者',
                      ),
                      onChanged: (text) {
                        model.author = text;
                      },
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          // 追加の処理
                          try {
                            await model.addBook();
                            Navigator.of(context).pop(true);
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        // ignore: prefer_const_constructors
                        child: Text('追加する')),
                  ],
                ),
              );
            }),
          ),
        ));
  }
}
