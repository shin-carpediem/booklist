import 'package:booklist/login/login_model.dart';
import 'package:booklist/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
        create: (_) => LoginModel(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('ログイン'),
          ),
          body: Center(
            child: Consumer<LoginModel>(builder: (context, model, child) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: model.titleController,
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            hintText: 'Email',
                          ),
                          onChanged: (text) {
                            model.setEmail(text);
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
                            hintText: 'パスワード',
                          ),
                          onChanged: (text) {
                            model.setPassword(text);
                          },
                        ),
                        // ignore: prefer_const_constructors
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            model.startLoading();

                            // 追加の処理
                            try {
                              await model.signup();
                              Navigator.of(context).pop();
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } finally {
                              model.endLoading();
                            }
                          },
                          // ignore: prefer_const_constructors
                          child: Text('ログイン'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // 画面遷移
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          // ignore: prefer_const_constructors
                          child: Text('新規登録の方はこちら'),
                        ),
                      ],
                    ),
                  ),
                  if (model.isLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            }),
          ),
        ));
  }
}
