import 'package:booklist/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'edit_book_model.dart';

// ignore: use_key_in_widget_constructors
class EditBookPage extends StatelessWidget {
  final Book book;
  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  EditBookPage(this.book);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBookModel>(
        create: (_) => EditBookModel(book),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('本を編集'),
          ),
          body: Center(
            child: Consumer<EditBookModel>(builder: (context, model, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: model.titleController,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: '本のタイトル',
                      ),
                      onChanged: (text) {
                        model.setTitle(text);
                        // model.notifyListeners();
                      },
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: model.authorController,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        hintText: '本の著者',
                      ),
                      onChanged: (text) {
                        model.setAuthor(text);
                      },
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        onPressed: model.isUpdated()
                            ? () async {
                                // 追加の処理
                                try {
                                  await model.update();
                                  Navigator.of(context).pop(model.title);
                                } catch (e) {
                                  final snackBar = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(e.toString()),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            : null,
                        // ignore: prefer_const_constructors
                        child: Text('更新する')),
                  ],
                ),
              );
            }),
          ),
        ));
  }
}
