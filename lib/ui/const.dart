import 'package:flutter/material.dart';

goToPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => page,
  ));
}

TextStyle textStyle = const TextStyle(fontSize: 20);

AppBar buildAppBar(String title) => AppBar(
      title: Text(title),
      centerTitle: true,
    );

showSnackBar(BuildContext context, String content, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: error ? Colors.red : null,
      content: Text(content),
      duration: const Duration(seconds: 2)));
}
