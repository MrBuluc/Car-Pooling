import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

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

Divider divider = const Divider(
  height: 1,
  color: Colors.grey,
);

String convertMonth(int month) {
  switch (month) {
    case 1:
      return "January";
    case 2:
      return "February";
    case 3:
      return "March";
    case 4:
      return "April";
    case 5:
      return "May";
    case 6:
      return "June";
    case 7:
      return "July";
    case 8:
      return "August";
    case 9:
      return "September";
    case 10:
      return "October";
    case 11:
      return "November";
    default:
      return "December";
  }
}

String addZeroToLessThanTenMinutes(int minutes) =>
    minutes < 10 ? "0$minutes" : minutes.toString();

RoadOption roadOption = const RoadOption(roadColor: Colors.red, roadWidth: 10);
