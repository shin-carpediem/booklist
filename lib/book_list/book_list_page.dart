// ignore_for_file: prefer_const_constructors

import 'package:booklist/add_book/add_book_page.dart';
import 'package:booklist/book_list/book_list_model.dart';
import 'package:booklist/domain/book.dart';
import 'package:booklist/edit_book/edit_book_page.dart';
import 'package:booklist/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
        create: (_) => BookListModel()..fetchBookList(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('本一覧'),
            actions: [
              IconButton(
                  onPressed: () async {
                    // 画面遷移
                  await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                    fullscreenDialog: true,
                  ),
                );
                  },
                  icon: Icon(Icons.person)),
            ],
          ),
          body: Center(
            child: Consumer<BookListModel>(builder: (context, model, child) {
              final List<Book>? books = model.books;

              if (books == null) {
                return const CircularProgressIndicator();
              }

              final widgets = books
                  .map(
                    (book) => Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      child: ListTile(
                        leading:
                            book.img != null ? Image.network(book.img!) : null,
                        title: Text(book.title),
                        subtitle: Text(book.author),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: '編集',
                          color: Colors.grey.shade200,
                          icon: Icons.edit,
                          onTap: () async {
                            // 編集画面に遷移
                            // 画面遷移
                            final String? title = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBookPage(book),
                              ),
                            );

                            if (title != null) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('$titleを編集しました'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }

                            model.fetchBookList();
                          },
                          closeOnTap: false,
                        ),
                        IconSlideAction(
                            caption: '削除',
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () async {
                              // 削除しますかと聞き、はいだったら削除
                              await showConfirmDialog(context, book, model);
                            }),
                      ],
                    ),
                  )
                  .toList();
              return ListView(children: widgets);
            }),
          ),
          floatingActionButton:
              Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              onPressed: () async {
                // 画面遷移
                final bool? added = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(),
                    fullscreenDialog: true,
                  ),
                );

                if (added != null && added) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('本を追加しました'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                model.fetchBookList();
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          }),
        ));
  }

  Future showConfirmDialog(
    BuildContext context,
    Book book,
    BookListModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("『${book.title}』を削除しますか？"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                // modelで削除
                await model.delete(book);
                Navigator.pop(context);

                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('『${book.title}』を削除しました'),
                );
                model.fetchBookList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
