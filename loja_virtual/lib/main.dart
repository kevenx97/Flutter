import 'package:flutter/material.dart';
import 'package:loja_virtual/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Roupas',
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800],
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepOrange[300],
        fontFamily: 'Raleway',
        iconTheme: IconThemeData(color: Colors.blueGrey[300])
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
