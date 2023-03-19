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
