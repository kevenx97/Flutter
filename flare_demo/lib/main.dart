import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'custom_buttom.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isPaused = true;
  String _animation = 'toast';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Flutter Animation')),
      body: FlareActor(
        'assets/toaster.flr',
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: _animation,
        isPaused: _isPaused,
        callback: (string) {
          setState(() {
            _isPaused = true;
            _animation = '';
          });
        },
      ),
      floatingActionButton: CustomButton(
        onPressed: () {
          setState(() {
            _animation = 'toast';
            _isPaused = false;
          });
        },
      ),
    );
  }
}
