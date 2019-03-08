import 'package:flutter/material.dart';
import 'package:gifs/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.white,
    ),
    debugShowCheckedModeBanner: false,
  ));
}
